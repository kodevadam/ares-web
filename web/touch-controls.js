/**
 * web/touch-controls.js
 *
 * Virtual N64 gamepad overlay for touch screens.
 *
 * Layout (landscape):
 *   Left side:  analog stick (large circle), D-pad (cross)
 *   Right side: A, B, Z, Start, L/R shoulders, C-buttons
 *   Centre:     Start button
 *
 * Uses pointer events (works for both touch and mouse) and writes
 * directly to the Module via ares_set_button / ares_set_axis.
 *
 * Call TouchControls.init() after Module is ready.
 */

'use strict';

const TouchControls = (() => {
  let Module = null;
  let overlay = null;

  // Track active pointer → button/axis mapping so we can release on pointerup.
  const activePointers = new Map();  // pointerId → { type, ... }

  // ---------------------------------------------------------------------------
  // Button layout definitions
  // ---------------------------------------------------------------------------

  const BUTTONS = [
    // D-pad
    { id: 'dp-up',    n64: 0,  label: '▲',  side: 'left',  x: 18, y: 55, w: 12, h: 12 },
    { id: 'dp-down',  n64: 1,  label: '▼',  side: 'left',  x: 18, y: 79, w: 12, h: 12 },
    { id: 'dp-left',  n64: 2,  label: '◀',  side: 'left',  x:  6, y: 67, w: 12, h: 12 },
    { id: 'dp-right', n64: 3,  label: '▶',  side: 'left',  x: 30, y: 67, w: 12, h: 12 },
    // Face buttons (right side)
    { id: 'btn-b',    n64: 4,  label: 'B',   side: 'right', x: 72, y: 67, w: 13, h: 13 },
    { id: 'btn-a',    n64: 5,  label: 'A',   side: 'right', x: 87, y: 57, w: 13, h: 13 },
    // C buttons
    { id: 'c-up',     n64: 6,  label: 'C↑',  side: 'right', x: 87, y: 30, w: 10, h: 10 },
    { id: 'c-down',   n64: 7,  label: 'C↓',  side: 'right', x: 87, y: 50, w: 10, h: 10 },
    { id: 'c-left',   n64: 8,  label: 'C←',  side: 'right', x: 76, y: 40, w: 10, h: 10 },
    { id: 'c-right',  n64: 9,  label: 'C→',  side: 'right', x: 98, y: 40, w: 10, h: 10 },
    // Shoulders (top)
    { id: 'btn-l',    n64: 10, label: 'L',   side: 'left',  x:  2, y:  2, w: 18, h:  8 },
    { id: 'btn-r',    n64: 11, label: 'R',   side: 'right', x: 80, y:  2, w: 18, h:  8 },
    // Z trigger
    { id: 'btn-z',    n64: 12, label: 'Z',   side: 'left',  x: 22, y:  2, w: 12, h:  8 },
    // Start
    { id: 'btn-start',n64: 13, label: 'START', side: 'center', x: 46, y: 60, w: 8, h: 6 },
  ];

  // Analog stick centre (percentage of overlay width/height)
  const STICK_CX = 18; // % from left
  const STICK_CY = 40; // % from top
  const STICK_R  =  8; // % radius of dead zone + range

  // ---------------------------------------------------------------------------
  // Build DOM
  // ---------------------------------------------------------------------------

  function buildOverlay() {
    overlay = document.createElement('div');
    overlay.id = 'touch-overlay';
    overlay.style.cssText = `
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 500;
      display: none;
    `;

    // SVG-based layout for resolution-independence.
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('viewBox', '0 0 100 100');
    svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
    svg.style.cssText = 'width:100%;height:100%;pointer-events:all;';

    // Buttons.
    BUTTONS.forEach((btn) => {
      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      rect.setAttribute('id', btn.id);
      rect.setAttribute('x', btn.x);
      rect.setAttribute('y', btn.y);
      rect.setAttribute('width', btn.w);
      rect.setAttribute('height', btn.h);
      rect.setAttribute('rx', '2');
      rect.style.cssText = 'fill:rgba(255,255,255,0.15);stroke:rgba(255,255,255,0.4);stroke-width:0.3;cursor:pointer;';
      svg.appendChild(rect);

      const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      text.setAttribute('x', btn.x + btn.w / 2);
      text.setAttribute('y', btn.y + btn.h / 2 + 1.5);
      text.setAttribute('text-anchor', 'middle');
      text.setAttribute('dominant-baseline', 'central');
      text.style.cssText = 'fill:rgba(255,255,255,0.8);font-size:2.5px;pointer-events:none;';
      text.textContent = btn.label;
      svg.appendChild(text);
    });

    // Analog stick — outer ring.
    const stickOuter = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    stickOuter.setAttribute('id', 'stick-outer');
    stickOuter.setAttribute('cx', STICK_CX);
    stickOuter.setAttribute('cy', STICK_CY);
    stickOuter.setAttribute('r',  STICK_R);
    stickOuter.style.cssText = 'fill:rgba(255,255,255,0.08);stroke:rgba(255,255,255,0.3);stroke-width:0.3;';
    svg.appendChild(stickOuter);

    // Analog stick — thumb nub.
    const stickNub = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    stickNub.setAttribute('id', 'stick-nub');
    stickNub.setAttribute('cx', STICK_CX);
    stickNub.setAttribute('cy', STICK_CY);
    stickNub.setAttribute('r',  3.5);
    stickNub.style.cssText = 'fill:rgba(255,255,255,0.25);stroke:rgba(255,255,255,0.5);stroke-width:0.3;';
    svg.appendChild(stickNub);

    overlay.appendChild(svg);
    document.body.appendChild(overlay);

    // Attach pointer events to SVG.
    svg.addEventListener('pointerdown',  onPointerDown,  { passive: false });
    svg.addEventListener('pointermove',  onPointerMove,  { passive: false });
    svg.addEventListener('pointerup',    onPointerUp,    { passive: false });
    svg.addEventListener('pointercancel', onPointerUp,   { passive: false });
  }

  // ---------------------------------------------------------------------------
  // SVG coordinate helpers
  // ---------------------------------------------------------------------------

  function svgPoint(e) {
    const svg = overlay.querySelector('svg');
    const pt  = svg.createSVGPoint();
    pt.x = e.clientX;
    pt.y = e.clientY;
    return pt.matrixTransform(svg.getScreenCTM().inverse());
  }

  function hitTestButton(svgX, svgY) {
    for (const btn of BUTTONS) {
      if (svgX >= btn.x && svgX <= btn.x + btn.w &&
          svgY >= btn.y && svgY <= btn.y + btn.h) {
        return btn;
      }
    }
    return null;
  }

  function hitTestStick(svgX, svgY) {
    const dx = svgX - STICK_CX, dy = svgY - STICK_CY;
    return dx * dx + dy * dy <= (STICK_R * 1.5) * (STICK_R * 1.5);
  }

  // ---------------------------------------------------------------------------
  // Pointer handlers
  // ---------------------------------------------------------------------------

  function onPointerDown(e) {
    e.preventDefault();
    overlay.querySelector('svg').setPointerCapture(e.pointerId);
    const pt = svgPoint(e);
    const btn = hitTestButton(pt.x, pt.y);
    if (btn) {
      Module._ares_set_button(0, btn.n64, 1);
      activePointers.set(e.pointerId, { type: 'btn', n64: btn.n64 });
      highlightButton(btn.id, true);
      return;
    }
    if (hitTestStick(pt.x, pt.y)) {
      activePointers.set(e.pointerId, { type: 'stick', startX: pt.x, startY: pt.y });
      updateStick(pt.x, pt.y);
    }
  }

  function onPointerMove(e) {
    e.preventDefault();
    const info = activePointers.get(e.pointerId);
    if (!info) return;
    if (info.type === 'stick') {
      const pt = svgPoint(e);
      updateStick(pt.x, pt.y);
    }
  }

  function onPointerUp(e) {
    e.preventDefault();
    const info = activePointers.get(e.pointerId);
    if (!info) return;
    activePointers.delete(e.pointerId);
    if (info.type === 'btn') {
      Module._ares_set_button(0, info.n64, 0);
      BUTTONS.filter(b => b.n64 === info.n64).forEach(b => highlightButton(b.id, false));
    } else if (info.type === 'stick') {
      // Release: centre the nub and zero the axis.
      const nub = overlay.querySelector('#stick-nub');
      nub.setAttribute('cx', STICK_CX);
      nub.setAttribute('cy', STICK_CY);
      Module._ares_set_axis(0, 0, 0);
      Module._ares_set_axis(0, 1, 0);
    }
  }

  function updateStick(svgX, svgY) {
    let dx = svgX - STICK_CX, dy = svgY - STICK_CY;
    const dist = Math.sqrt(dx * dx + dy * dy);
    if (dist > STICK_R) { dx = dx / dist * STICK_R; dy = dy / dist * STICK_R; }

    const nub = overlay.querySelector('#stick-nub');
    nub.setAttribute('cx', STICK_CX + dx);
    nub.setAttribute('cy', STICK_CY + dy);

    const axisX = Math.round((dx / STICK_R) * 32767);
    const axisY = Math.round((dy / STICK_R) * 32767);
    Module._ares_set_axis(0, 0, axisX);
    Module._ares_set_axis(0, 1, axisY);
  }

  function highlightButton(id, active) {
    const el = overlay.querySelector(`#${id}`);
    if (el) el.style.fill = active ? 'rgba(255,255,255,0.45)' : 'rgba(255,255,255,0.15)';
  }

  // ---------------------------------------------------------------------------
  // Show / hide
  // ---------------------------------------------------------------------------

  function show() {
    if (overlay) overlay.style.display = 'block';
  }

  function hide() {
    if (overlay) overlay.style.display = 'none';
  }

  function detectTouch() {
    // Show touch controls when touch input is detected and hide when mouse/kbd used.
    window.addEventListener('touchstart', () => show(), { once: true, passive: true });
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  function init(moduleRef) {
    Module = moduleRef;
    buildOverlay();
    detectTouch();

    // Expose toggle for the settings panel.
    window.toggleTouchControls = () => {
      if (!overlay) return;
      const vis = overlay.style.display !== 'none';
      vis ? hide() : show();
    };
  }

  return { init, show, hide };
})();
