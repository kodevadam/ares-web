auto VI::readWord(u32 address, Thread& thread) -> u32 {
  address = (address & 0x3f) >> 2;
  n32 data;

  if(address == 0) {
    //VI_CONTROL
    data.bit( 0, 1) = io.colorDepth;
    data.bit( 2)    = io.gammaDither;
    data.bit( 3)    = io.gamma;
    data.bit( 4)    = io.divot;
    data.bit( 5)    = io.reserved.bit(5);
    data.bit( 6)    = io.serrate;
    data.bit( 7)    = io.reserved.bit(7);
    data.bit( 8, 9) = io.antialias;
    data.bit(10,15) = io.reserved.bit(10,15);
  }

  if(address == 1) {
    //VI_DRAM_ADDRESS
    data.bit(0,23) = io.dramAddress;
  }

  if(address == 2) {
    //VI_H_WIDTH
    data.bit(0,11) = io.width;
  }

  if(address == 3) {
    //VI_V_INTR
    data.bit(0,9) = io.coincidence;
  }

  if(address == 4) {
    //VI_V_CURRENT_LINE
    data.bit(0)   = io.field;
    data.bit(1,9) = io.vcounter;
  }

  if(address == 5) {
    //VI_TIMING
    data.bit( 0, 7) = io.hsyncWidth;
    data.bit( 8,15) = io.colorBurstWidth;
    data.bit(16,19) = io.vsyncWidth;
    data.bit(20,29) = io.colorBurstHsync;
  }

  if(address == 6) {
    //VI_V_SYNC
    data.bit(0,9) = io.halfLinesPerField;
  }

  if(address == 7) {
    //VI_H_SYNC
    data.bit( 0,11) = io.quarterLineDuration;
    data.bit(16,20) = io.leapPattern;
  }

  if(address == 8) {
    //VI_H_SYNC_LEAP
    data.bit( 0,11) = io.hsyncLeap[0];
    data.bit(16,27) = io.hsyncLeap[1];
  }

  if(address == 9) {
    //VI_H_VIDEO
    data.bit( 0, 9) = io.hend;
    data.bit(16,25) = io.hstart;
  }

  if(address == 10) {
    //VI_V_VIDEO
    data.bit( 0, 9) = io.vend;
    data.bit(16,25) = io.vstart;
  }

  if(address == 11) {
    //VI_V_BURST
    data.bit( 0, 9) = io.colorBurstEnd;
    data.bit(16,25) = io.colorBurstStart;
  }

  if(address == 12) {
    //VI_X_SCALE
    data.bit( 0,11) = io.xscale;
    data.bit(16,27) = io.xsubpixel;
  }

  if(address == 13) {
    //VI_Y_SCALE
    data.bit( 0,11) = io.yscale;
    data.bit(16,27) = io.ysubpixel;
  }

  debugger.io(Read, address, data);
  return data;
}

auto VI::writeWord(u32 address, u32 data_, Thread& thread) -> void {
  address = (address & 0x3f) >> 2;
  n32 data = data_;

  #if defined(VULKAN)
  if (vulkan.enable) vulkan.writeWord(address, data);
  #elif defined(WEBGPU)
  if (webgpurdp.enable) webgpurdp.writeWord(address, data);
  #endif

  if(address == 0) {
    //VI_CONTROL
    auto prevColorDepth = io.colorDepth;
    io.colorDepth          = data.bit( 0, 1);
    io.gammaDither         = data.bit( 2);
    io.gamma               = data.bit( 3);
    io.divot               = data.bit( 4);
    io.reserved.bit(5)     = data.bit( 5);
    io.serrate             = data.bit( 6);
    io.reserved.bit(7)     = data.bit( 7);
    io.antialias           = data.bit( 8, 9);
    io.reserved.bit(10,15) = data.bit(10,15);
    // Always log colorDepth transitions (0→nonzero or changes), limited to first 32 total
    static int viCtrlDbg = 0;
    bool interesting = (prevColorDepth != io.colorDepth) || (io.colorDepth != 0 && viCtrlDbg < 4);
    if(viCtrlDbg < 32 || interesting) {
      if(interesting || viCtrlDbg < 8)
        fprintf(stderr, "[VI_CONTROL#%d] write=0x%08x colorDepth=%d->%d dramAddr=0x%06x width=%u halfLines=%u coi=%u\n",
                viCtrlDbg, (u32)data_, (int)(u32)prevColorDepth, (int)io.colorDepth,
                (u32)io.dramAddress, (u32)io.width,
                (u32)io.halfLinesPerField, (u32)io.coincidence);
      viCtrlDbg++;
    }
  }

  if(address == 1) {
    //VI_DRAM_ADDRESS
    io.dramAddress = data.bit(0,23);
    static int viDramDbg = 0;
    if(viDramDbg++ < 8)
      fprintf(stderr, "[VI_DRAM_ADDR#%d] write=0x%06x colorDepth=%d\n",
              viDramDbg-1, (u32)io.dramAddress, (int)io.colorDepth);
  }

  if(address == 2) {
    //VI_H_WIDTH
    io.width = data.bit(0,11);
    static int viWidthDbg = 0;
    if(viWidthDbg++ < 8)
      fprintf(stderr, "[VI_H_WIDTH#%d] write=%u colorDepth=%d dramAddr=0x%06x\n",
              viWidthDbg-1, (u32)io.width, (int)io.colorDepth, (u32)io.dramAddress);
  }

  if(address == 3) {
    //VI_V_INTR
    io.coincidence = data.bit(0,9);
  }

  if(address == 4) {
    //VI_V_CURRENT_LINE
    mi.lower(MI::IRQ::VI);
  }

  if(address == 5) {
    //VI_TIMING
    io.hsyncWidth      = data.bit( 0, 7);
    io.colorBurstWidth = data.bit( 8,15);
    io.vsyncWidth      = data.bit(16,19);
    io.colorBurstHsync = data.bit(20,29);
  }

  if(address == 6) {
    //VI_V_TOTAL
    io.halfLinesPerField = data.bit(0,9);
    static int viVtotalDbg = 0;
    if(viVtotalDbg++ < 4)
      fprintf(stderr, "[VI_V_TOTAL] halfLinesPerField=%u\n", (u32)io.halfLinesPerField);
  }

  if(address == 7) {
    //VI_H_TOTAL
    io.quarterLineDuration = data.bit( 0,11);
    io.leapPattern         = data.bit(16,20);
  }

  if(address == 8) {
    //VI_H_SYNC_LEAP
    io.hsyncLeap[0] = data.bit( 0,11);
    io.hsyncLeap[1] = data.bit(16,27);
  }

  if(address == 9) {
    //VI_H_VIDEO
    io.hend   = data.bit( 0, 9);
    io.hstart = data.bit(16,25);
  }

  if(address == 10) {
    //VI_V_VIDEO
    io.vend   = data.bit( 0, 9);
    io.vstart = data.bit(16,25);
  }

  if(address == 11) {
    //VI_V_BURST
    io.colorBurstEnd   = data.bit( 0, 9);
    io.colorBurstStart = data.bit(16,25);
  }

  if(address == 12) {
    //VI_X_SCALE
    io.xscale    = data.bit( 0,11);
    io.xsubpixel = data.bit(16,27);
  }

  if(address == 13) {
    //VI_Y_SCALE
    io.yscale    = data.bit( 0,11);
    io.ysubpixel = data.bit(16,27);
  }

  debugger.io(Write, address, data);
}
