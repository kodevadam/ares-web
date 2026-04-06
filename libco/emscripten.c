/*
 * libco Emscripten fiber backend
 *
 * Uses the emscripten_fiber_* API introduced in Emscripten 1.39.0.
 * Each coroutine is an Emscripten fiber with its own C stack and asyncify stack.
 *
 * To enable, build with:
 *   -s ASYNCIFY
 * or the newer:
 *   -s FIBER_SUPPORT
 *
 * Stack sizes are controlled via LIBCO_STACKSIZE (default 1 MiB C stack) and
 * LIBCO_ASYNCIFY_STACKSIZE (default 16 KiB asyncify stack).
 */

#include <emscripten/fiber.h>
#include <stdlib.h>
#include <string.h>
#include "libco.h"

#ifndef LIBCO_STACKSIZE
  #define LIBCO_STACKSIZE (1 * 1024 * 1024)
#endif

#ifndef LIBCO_ASYNCIFY_STACKSIZE
  #define LIBCO_ASYNCIFY_STACKSIZE (16 * 1024)
#endif

typedef struct {
  emscripten_fiber_t fiber;
  void (*entry)(void);
  /* Backing storage for the C stack and asyncify stack */
  char* c_stack;
  char* asyncify_stack;
} co_fiber;

/* The primary (thread-entry) fiber is allocated statically. */
static co_fiber co_primary;
/* Pointer to the currently executing fiber. */
static co_fiber* co_current = NULL;

/* -------------------------------------------------------------------------- */
/* Public API                                                                  */
/* -------------------------------------------------------------------------- */

static void co_entry_trampoline(void* arg) {
  co_fiber* self = (co_fiber*)arg;
  self->entry();
  /* Coroutines should never return, but if they do, abort gracefully. */
  abort();
}

cothread_t co_active(void) {
  if(!co_current) return (cothread_t)&co_primary;
  return (cothread_t)co_current;
}

cothread_t co_derive(void* memory, unsigned int size, void (*entry)(void)) {
  (void)memory; (void)size; /* ignored — we allocate internally */
  co_fiber* fiber = (co_fiber*)malloc(sizeof(co_fiber));
  if(!fiber) return NULL;
  memset(fiber, 0, sizeof(co_fiber));

  fiber->entry = entry;
  fiber->c_stack = (char*)malloc(LIBCO_STACKSIZE);
  fiber->asyncify_stack = (char*)malloc(LIBCO_ASYNCIFY_STACKSIZE);
  if(!fiber->c_stack || !fiber->asyncify_stack) {
    free(fiber->c_stack);
    free(fiber->asyncify_stack);
    free(fiber);
    return NULL;
  }

  emscripten_fiber_init(&fiber->fiber,
    co_entry_trampoline, fiber,
    fiber->c_stack, LIBCO_STACKSIZE,
    fiber->asyncify_stack, LIBCO_ASYNCIFY_STACKSIZE);

  return (cothread_t)fiber;
}

cothread_t co_create(unsigned int size, void (*entry)(void)) {
  (void)size;
  return co_derive(NULL, 0, entry);
}

void co_delete(cothread_t co) {
  co_fiber* fiber = (co_fiber*)co;
  if(fiber == &co_primary) return; /* never delete the primary fiber */
  free(fiber->c_stack);
  free(fiber->asyncify_stack);
  free(fiber);
}

void co_switch(cothread_t co) {
  co_fiber* from;
  co_fiber* to = (co_fiber*)co;

  if(!co_current) {
    /* First switch: initialise the primary fiber as the current context */
    emscripten_fiber_init_from_current_context(
      &co_primary.fiber,
      co_primary.asyncify_stack,
      LIBCO_ASYNCIFY_STACKSIZE);
    co_current = &co_primary;
  }

  from = co_current;
  co_current = to;
  emscripten_fiber_swap(&from->fiber, &to->fiber);
}

int co_serializable(void) {
  return 0;
}
