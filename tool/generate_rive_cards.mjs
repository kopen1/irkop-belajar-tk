import { mkdirSync, writeFileSync } from 'node:fs';
import { createRiv } from '/tmp/rive-mcp/dist/rivWriter.js';

const OUT = 'assets/rive';
mkdirSync(OUT, { recursive: true });

const P = {
  huruf: ['#8FE0FF', '#4DB6E8', '#FF9DB7'], angka: ['#9BE7FF', '#4DB6E8', '#FFD45C'],
  hijaiyah: ['#A8F1D0', '#62C98B', '#FFD45C'], gambar: ['#FFD6A8', '#FFAB62', '#F58BA8'],
  warna: ['#D9D0FF', '#9B8AEF', '#FFAB62'], mewarnai: ['#FFD0DD', '#F58BA8', '#FFD45C'],
  titik: ['#FFF1B8', '#FFD45C', '#4DB6E8'], kuis: ['#C9C5FF', '#7667D8', '#62C98B'],
};

const rect = (id, x, y, width, height, fill, extra = {}) => ({ id, type: 'rect', x, y, width, height, cornerRadius: Math.min(28, Math.min(width, height) * .22), fill: { color: fill }, ...extra });
const gradRect = (id, x, y, width, height, colors, extra = {}) => ({ id, type: 'rect', x, y, width, height, cornerRadius: Math.min(28, Math.min(width, height) * .22), fill: { gradient: { type: 'linear', stops: [{ color: colors[0], position: 0 }, { color: colors[1], position: 1 }], start: { x: 0, y: 0 }, end: { x: width, y: height } } }, ...extra });
const ellipse = (id, x, y, radiusX, radiusY, fill, extra = {}) => ({ id, type: 'ellipse', x, y, radiusX, radiusY, fill: fill ? { color: fill } : undefined, ...extra });
const tri = (id, x, y, width, height, fill, rotation = 0, extra = {}) => ({ id, type: 'triangle', x, y, width, height, rotation, fill: { color: fill }, ...extra });
const path = (id, points, stroke, extra = {}) => ({ id, type: 'polygon', x: 0, y: 0, points, closed: false, stroke: { color: stroke, thickness: 7 }, ...extra });
const k = (frame, value, easing = 'ease-in-out') => ({ frame, value, easing });
const track = (target, property, keyframes) => ({ target, property, keyframes });

function scene(colors, iconShapes) {
  const icons = iconShapes.map((s) => ({ ...s, parent: 'icon' }));
  const shapes = [
    gradRect('bg_shape', 160, 150, 250, 235, colors, { z: 10 }),
    ellipse('shadow', 160, 278, 82, 18, '#4A6B7F', { opacity: .20, z: 20 }),
    ellipse('glow_ring', 160, 150, 122, 114, null, { opacity: 0, stroke: { color: colors[1], thickness: 5 }, z: 30 }),
    ...icons,
    ellipse('sparkle_a', 92, 88, 5, 5, '#FFFFFF', { opacity: 0, z: 90 }),
    ellipse('sparkle_b', 232, 82, 4, 4, colors[2], { opacity: 0, z: 90 }),
    ellipse('sparkle_c', 238, 226, 5, 5, '#FFFFFF', { opacity: 0, z: 90 }),
    ellipse('sparkle_d', 82, 220, 3, 3, colors[2], { opacity: 0, z: 90 }),
  ];

  const animations = [
    { name: 'idle', fps: 60, duration: 120, loop: 'loop', tracks: [
      track('bg_shape', 'y', [k(0, 150), k(60, 144), k(120, 150)]),
      track('icon', 'y', [k(0, 0), k(60, -6), k(120, 0)]),
      track('icon', 'rotation', [k(0, -2), k(60, 2), k(120, -2)]),
      track('shadow', 'scaleX', [k(0, 1), k(60, .86), k(120, 1)]),
      track('shadow', 'scaleY', [k(0, 1), k(60, .82), k(120, 1)]),
      track('shadow', 'opacity', [k(0, .20), k(60, .12), k(120, .20)]),
    ] },
    { name: 'pressed', fps: 60, duration: 9, loop: 'oneShot', tracks: [
      track('bg_shape', 'scaleX', [k(0, 1), k(7, .92, 'ease-out-back'), k(9, .92)]),
      track('bg_shape', 'scaleY', [k(0, 1), k(7, .92, 'ease-out-back'), k(9, .92)]),
      track('icon', 'scaleX', [k(0, 1), k(7, .92, 'ease-out-back'), k(9, .92)]),
      track('icon', 'scaleY', [k(0, 1), k(7, .92, 'ease-out-back'), k(9, .92)]),
      track('glow_ring', 'opacity', [k(0, 0), k(9, .60, 'ease-out')]),
      track('shadow', 'scaleX', [k(0, 1), k(9, .78, 'ease-out')]),
      track('shadow', 'opacity', [k(0, .20), k(9, .08, 'ease-out')]),
    ] },
    { name: 'released', fps: 60, duration: 36, loop: 'oneShot', tracks: [
      track('bg_shape', 'scaleX', [k(0, .92), k(10, 1.05, 'elastic-out'), k(24, 1)]),
      track('bg_shape', 'scaleY', [k(0, .92), k(10, 1.05, 'elastic-out'), k(24, 1)]),
      track('icon', 'scaleX', [k(0, .92), k(10, 1.05, 'elastic-out'), k(24, 1)]),
      track('icon', 'scaleY', [k(0, .92), k(10, 1.05, 'elastic-out'), k(24, 1)]),
      track('glow_ring', 'opacity', [k(0, .60), k(12, 1, 'ease-out'), k(36, 0, 'ease-in')]),
      ...['a','b','c','d'].map((s, i) => track(`sparkle_${s}`, 'opacity', [k(0, 0), k(7 + i, 1, 'ease-out'), k(36, 0, 'ease-in')])),
      track('sparkle_a', 'scaleX', [k(0, .5), k(10, 1.6, 'ease-out'), k(36, 1)]),
      track('sparkle_a', 'scaleY', [k(0, .5), k(10, 1.6, 'ease-out'), k(36, 1)]),
      track('shadow', 'scaleX', [k(0, .78), k(10, 1.08, 'elastic-out'), k(24, 1)]),
      track('shadow', 'opacity', [k(0, .08), k(10, .22, 'ease-out'), k(24, .20)]),
    ] },
  ];

  return {
    artboards: [{ name: 'WorldCard', width: 320, height: 320, groups: [{ id: 'icon', x: 0, y: 0 }], shapes,
      animations,
      stateMachine: {
        name: 'card_states', inputs: [{ name: 'touchState', type: 'number', initial: 0 }],
        states: [{ name: 'Idle', animation: 'idle' }, { name: 'Pressed', animation: 'pressed' }, { name: 'Released', animation: 'released' }],
        transitions: [
          { from: 'entry', to: 'Idle' },
          { from: 'Idle', to: 'Pressed', condition: { input: 'touchState', op: '==', value: 1 } },
          { from: 'Pressed', to: 'Released', condition: { input: 'touchState', op: '==', value: 2 } },
          { from: 'Released', to: 'Idle', condition: { input: 'touchState', op: '==', value: 0 } },
        ],
      },
    }],
  };
}

const cards = {
  dunia_huruf: scene(P.huruf, [
    tri('a_body', 160, 154, 104, 120, '#FFC85C', 0, { z: 50 }), ellipse('a_left_eye', 138, 132, 12, 14, '#FFFFFF', { z: 60 }), ellipse('a_right_eye', 182, 132, 12, 14, '#FFFFFF', { z: 60 }), ellipse('a_left_pupil', 140, 134, 5, 7, '#24445C', { z: 70 }), ellipse('a_right_pupil', 180, 134, 5, 7, '#24445C', { z: 70 }), ellipse('a_mouth', 160, 176, 16, 10, '#F05F78', { z: 70 }),
  ]),
  dunia_angka: scene(P.angka, [
    rect('one', 122, 150, 25, 100, '#FFFFFF', { z: 50 }), rect('two_top', 180, 108, 55, 24, '#FFD45C', { z: 50 }), rect('two_mid', 180, 150, 55, 24, '#FFD45C', { z: 50 }), rect('two_low', 140, 192, 95, 24, '#FFD45C', { z: 50 }), tri('two_diag_top', 205, 125, 55, 50, '#FFD45C', 90, { z: 51 }),
  ]),
  dunia_hijaiyah: scene(P.hijaiyah, [rect('mosque_body', 160, 174, 105, 70, '#FFF6D6', { z: 50 }), tri('mosque_dome', 160, 125, 100, 75, '#FFD45C', 0, { z: 55 }), rect('minaret_l', 108, 150, 22, 92, '#62C98B', { z: 55 }), rect('minaret_r', 212, 150, 22, 92, '#62C98B', { z: 55 }), ellipse('mosque_door', 160, 195, 18, 28, '#4DB6E8', { z: 60 })]),
  dunia_gambar: scene(P.gambar, [tri('cat_left_ear', 122, 112, 42, 50, '#FFAB62', 0, { z: 50 }), tri('cat_right_ear', 198, 112, 42, 50, '#FFAB62', 0, { z: 50 }), ellipse('cat_face', 160, 154, 60, 52, '#FFD166', { z: 52 }), ellipse('cat_eye_l', 140, 145, 8, 10, '#24445C', { z: 60 }), ellipse('cat_eye_r', 180, 145, 8, 10, '#24445C', { z: 60 }), tri('cat_nose', 160, 163, 12, 10, '#F58BA8', 0, { z: 62 }), ellipse('cat_mouth', 160, 178, 14, 8, '#F05F78', { z: 62 })]),
  dunia_warna: scene(P.warna, [ellipse('palette', 160, 155, 64, 52, '#FFF7E5', { z: 50 }), ellipse('red', 122, 140, 10, 10, '#F58BA8', { z: 60 }), ellipse('blue', 150, 122, 10, 10, '#4DB6E8', { z: 60 }), ellipse('green', 178, 122, 10, 10, '#62C98B', { z: 60 }), ellipse('yellow', 200, 148, 10, 10, '#FFD45C', { z: 60 }), ellipse('purple', 180, 180, 10, 10, '#9B8AEF', { z: 60 })]),
  mewarnai: scene(P.mewarnai, [rect('crayon_body', 145, 155, 32, 104, '#F58BA8', { z: 50 }), tri('crayon_tip', 145, 94, 32, 38, '#FFD45C', 0, { z: 55 }), rect('crayon_band', 145, 150, 32, 14, '#FFFFFF', { z: 60 }), rect('crayon_body2', 182, 165, 30, 86, '#9B8AEF', { z: 49 }), tri('crayon_tip2', 182, 111, 30, 34, '#FFD45C', 0, { z: 55 })]),
  titik_garis: scene(P.titik, [ellipse('dot1', 112, 118, 13, 13, '#F58BA8', { z: 55 }), ellipse('dot2', 160, 98, 13, 13, '#4DB6E8', { z: 55 }), ellipse('dot3', 208, 128, 13, 13, '#62C98B', { z: 55 }), ellipse('dot4', 190, 188, 13, 13, '#9B8AEF', { z: 55 }), ellipse('dot5', 126, 202, 13, 13, '#FFAB62', { z: 55 }), path('line_path', [{x:112,y:118},{x:160,y:98},{x:208,y:128},{x:190,y:188},{x:126,y:202}], '#4DB6E8', { z: 45 })]),
  kuis: scene(P.kuis, [ellipse('brain_l', 142, 150, 42, 50, '#F58BA8', { z: 50 }), ellipse('brain_r', 178, 150, 42, 50, '#F58BA8', { z: 50 }), ellipse('brain_center', 160, 160, 12, 34, '#FFD45C', { z: 55 }), ellipse('brain_dot1', 142, 130, 7, 7, '#FFFFFF', { z: 60 }), ellipse('brain_dot2', 178, 130, 7, 7, '#FFFFFF', { z: 60 }), ellipse('brain_dot3', 142, 172, 7, 7, '#FFFFFF', { z: 60 }), ellipse('brain_dot4', 178, 172, 7, 7, '#FFFFFF', { z: 60 })]),
};

for (const [name, spec] of Object.entries(cards)) {
  const { bytes, warnings } = createRiv(spec);
  if (warnings.length) console.warn(name, warnings);
  writeFileSync(`${OUT}/${name}.riv`, Buffer.from(bytes));
  console.log(`${name}.riv ${bytes.length} bytes`);
}
