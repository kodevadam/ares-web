#include <n64/n64.hpp>
#include <nall/gdb/server.hpp>
#include <cstdio>

namespace ares::Nintendo64 {

CPU cpu;
#include "context.cpp"
#include "dcache.cpp"
#include "tlb.cpp"
#include "memory.cpp"
#include "exceptions.cpp"
#include "algorithms.cpp"
#include "interpreter.cpp"
#include "interpreter-ipu.cpp"
#include "interpreter-scc.cpp"
#include "interpreter-fpu.cpp"
#include "interpreter-cop2.cpp"
#include "recompiler.cpp"
#include "debugger.cpp"
#include "serialization.cpp"
#include "disassembler.cpp"
#include "emux.cpp"

auto CPU::load(Node::Object parent) -> void {
  node = parent->append<Node::Object>("CPU");
  debugger.load(node);
}

auto CPU::unload() -> void {
  debugger.unload();
  node.reset();
}

auto CPU::main() -> void {
#if defined(ARES_WEB)
  // Idle loop detection: track the last two PCs to detect branch-to-self spins.
  u64 prevPc = ~ipu.pc;
  u64 pprevPc = ~ipu.pc;
  static u64 s_totalIters = 0;
  u64 iters = 0;
  static constexpr u64 MAX_ITERS = 3000000ULL;
  fprintf(stderr, "[cpu.main] enter pc=%08x vi.refreshed=%d vi.clock=%lld vi.hlpf=%u vi.coi=%u vi.cd=%u vi.dram=0x%06x vi.w=%u\n",
    (unsigned)(ipu.pc & 0xffffffffu), (int)vi.refreshed, (long long)vi.clock,
    (unsigned)(u32)vi.io.halfLinesPerField, (unsigned)(u32)vi.io.coincidence,
    (unsigned)(u32)vi.io.colorDepth, (unsigned)(u32)vi.io.dramAddress,
    (unsigned)(u32)vi.io.width);
#endif
  while(!vi.refreshed && GDB::server.reportPC(ipu.pc & 0xFFFFFFFF)) {
#if defined(ARES_WEB)
    ++iters;
    if(iters == 1) {
      fprintf(stderr, "[cpu.main] first instruction pc=%08x\n",
        (unsigned)(ipu.pc & 0xffffffffu));
    }
    if(iters > MAX_ITERS) {
      fprintf(stderr, "[cpu.main] cap hit: total=%llu vi.clock=%lld vi.inactive=%u vi.hlpf=%u vi.coi=%u pc=%08x\n",
        (unsigned long long)(s_totalIters + iters),
        (long long)vi.clock,
        (unsigned)vi.inactiveCounter,
        (unsigned)(u32)vi.io.halfLinesPerField,
        (unsigned)(u32)vi.io.coincidence,
        (unsigned)(ipu.pc & 0xffffffffu));
      break;
    }
    if(iters % 100000ULL == 0) {
      fprintf(stderr, "[cpu.main] iter %llu vi.clock=%lld vi.inactive=%u vi.hlpf=%u vi.coi=%u pc=%08x\n",
        (unsigned long long)(s_totalIters + iters),
        (long long)vi.clock,
        (unsigned)vi.inactiveCounter,
        (unsigned)(u32)vi.io.halfLinesPerField,
        (unsigned)(u32)vi.io.coincidence,
        (unsigned)(ipu.pc & 0xffffffffu));
    }
#endif
    instruction();
#if defined(ARES_WEB)
    if(iters == 1) {
      fprintf(stderr, "[cpu.main] after first instruction pc=%08x Thread::clock=%lld\n",
        (unsigned)(ipu.pc & 0xffffffffu), (long long)Thread::clock);
    }
#endif
    synchronize();
#if defined(ARES_WEB)
    if(iters == 1) {
      fprintf(stderr, "[cpu.main] after first synchronize vi.clock=%lld vi.inactive=%u\n",
        (long long)vi.clock, (unsigned)vi.inactiveCounter);
    }
    // If PC oscillates between two values (branch + delay slot), we are in
    // an idle spin.  Only fast-forward when interrupts are globally enabled
    // and none are already pending (so we don't skip over a real event).
    if(ipu.pc == pprevPc && ipu.pc != prevPc) {
      if(scc.status.interruptEnable && !scc.status.exceptionLevel &&
         !(scc.cause.interruptPending & scc.status.interruptMask)) {
        step(1024);
        synchronize();
      }
    }
    pprevPc = prevPc;
    prevPc  = ipu.pc;
#endif
  }
#if defined(ARES_WEB)
  s_totalIters += iters;
  fprintf(stderr, "[cpu.main] exit iters=%llu total=%llu vi.refreshed=%d\n",
    (unsigned long long)iters, (unsigned long long)s_totalIters, (int)vi.refreshed);
#endif

  vi.refreshed = false;
  queue.remove(Queue::GDB_Poll);
  if(GDB::server.hasClient()) {
    queue.insert(Queue::GDB_Poll, (93750000*2)/60/240);
  }
}

auto CPU::gdbPoll() -> void {
  if(GDB::server.hasClient()) {
    GDB::server.updateLoop();
    queue.insert(Queue::GDB_Poll, (93750000*2)/60/240);
  }
}

auto CPU::synchronize() -> void {
  auto clocks = Thread::clock;
  Thread::clock = 0;

   vi.clock -= clocks;
   ai.clock -= clocks;
  rsp.clock -= clocks;
  rdp.clock -= clocks;
  pif.clock -= clocks;
  vi.main();
  ai.main();
  rsp.main();
  rdp.main();
  pif.main();

  queue.step(clocks, [](u32 event) {
    switch(event) {
    case Queue::PI_DMA_Read:   return pi.dmaFinished();
    case Queue::PI_DMA_Write:  return pi.dmaFinished();
    case Queue::PI_BUS_Write:  return pi.writeFinished();
    case Queue::SI_DMA_Read:   return si.dmaRead();
    case Queue::SI_DMA_Write:  return si.dmaWrite();
    case Queue::SI_BUS_Write:  return si.writeFinished();
    case Queue::RTC_Tick:      return cartridge.rtc.tick();
    case Queue::EEPROM_Write:  return cartridge.eepromFinish();
    case Queue::DD_Clock_Tick:  return dd.rtc.tickClock();
    case Queue::DD_MECHA_Response:  return dd.mechaResponse();
    case Queue::DD_BM_Request:  return dd.bmRequest();
    case Queue::DD_Motor_Mode:  return dd.motorChange();
    case Queue::GDB_Poll:      return cpu.gdbPoll();
    }
  });

  clocks >>= 1;
  if(scc.count < scc.compare && scc.count + clocks >= scc.compare) {
    scc.cause.interruptPending.bit(Interrupt::Timer) = 1;
  }
  scc.count += clocks;
  profile.cpuCycles += clocks;
  if (scc.status.exceptionLevel) profile.cpuCyclesExc += clocks;
}

auto CPU::instruction() -> void {
  if(auto interrupts = scc.cause.interruptPending & scc.status.interruptMask) {
    if(scc.status.interruptEnable && !scc.status.exceptionLevel && !scc.status.errorLevel) {
      debugger.interrupt(scc.cause.interruptPending);
      step(1 * 2);
      return exception.interrupt();
    }
  }
  if (scc.nmiPending) {
    debugger.nmi();
    step(1 * 2);
    return exception.nmi();
  }
  if (scc.sysadFrozen) {
    step(1 * 2);
    return;
  }

#if defined(ARES_WEB)
  // ── Instruction-word cache fast path ──────────────────────────────────
  // On a cache hit we skip devirtualize() + icache.fetch() entirely and
  // directly decode the cached word.  step(1*2) accounts for the cycle
  // normally charged inside fetch().  Exceptions and TLB faults can't
  // occur on a hit because the entry was populated from a successful
  // prior fetch at the same virtual address.
  {
    auto& ce = iwordCache[ipu.pc >> 2 & IWC_MASK];
    if (ce.vaddr == ipu.pc) {
      step(1 * 2);
      pipeline.begin();
      instructionPrologue(ipu.pc, ce.word);
      decoderEXECUTE(ce.word);
      instructionEpilogue<0>();
      pipeline.end();
      return;
    }
  }
  // ── Cache miss: fall through to normal fetch, then populate cache ──────
#endif

  auto access = devirtualize<Read, Word>(ipu.pc);
  if(!access) return;

  if(Accuracy::CPU::Recompiler && recompiler.enabled && access.cache) {
    if(vaddrAlignedError<Word>(access.vaddr, false)) return;
    auto block = recompiler.block(ipu.pc, access.paddr, GDB::server.hasBreakpoints());
    if(block) {
      block->execute(*this);
      return;
    }
  }

  auto data = fetch(access);
  if (!data) return;

#if defined(ARES_WEB)
  // Populate cache for next execution of this address.
  iwordCache[ipu.pc >> 2 & IWC_MASK] = { ipu.pc, *data };
#endif

  pipeline.begin();
  instructionPrologue(ipu.pc, *data);
  decoderEXECUTE(*data);
  instructionEpilogue<0>();
  pipeline.end();
}

auto CPU::instructionPrologue(u64 address, u32 instruction) -> void {
  debugger.instruction(address, instruction);
}

template<bool Recompiled>
auto CPU::instructionEpilogue() -> void {
  if constexpr(!Recompiled) {
    ipu.r[0].u64 = 0;
  }
}

auto CPU::power(bool reset) -> void {
  Thread::reset();
#if defined(ARES_WEB)
  iwordCacheFlush();
#endif

  context.endian = Context::Endian::Big;
  context.mode = Context::Mode::Kernel;
  context.bits = 64;
  for(auto& segment : context.segment) segment = Context::Segment::Unused;
  icache.power(reset);
  dcache.power(reset);
  for(auto& entry : tlb.entry) entry = {}, entry.synchronize();
  tlb.physicalAddress = 0;
  for(auto& r : ipu.r) r.u64 = 0;
  ipu.lo.u64 = 0;
  ipu.hi.u64 = 0;
  ipu.r[29].u64 = 0xffff'ffff'a400'1ff0ull;  //stack pointer
  pipeline.setPc(0xffff'ffff'bfc0'0000ull);
  scc = {};
  for(auto& r : fpu.r) r.u64 = 0;
  fpu.csr = {};
  cop2 = {};
  emuxState = {};
  fenv.setRound(float_env::toNearest);
  context.setMode();

  if constexpr(Accuracy::CPU::Recompiler) {
    auto buffer = ares::Memory::FixedAllocator::get().tryAcquire(63_MiB);
    recompiler.allocator.resize(63_MiB, bump_allocator::executable, buffer);
    recompiler.reset();
  }
}

}
