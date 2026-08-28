/* ===== AudioEngine: narasi (Web Speech) + efek suara & musik (Web Audio) ===== */
const AudioEngine = (() => {
  let ctx = null, master = null, musicGain = null;
  let musicTimer = null, nextNoteTime = 0, noteIndex = 0;
  let sfxOn = true, musicOn = true;
  let idVoice = null;

  /* Musik kotak musik yang lembut (pentatonik, loop) */
  const NOTE = { G4: 392.0, A4: 440.0, C5: 523.25, D5: 587.33, E5: 659.25, G5: 783.99, A5: 880.0, C6: 1046.5 };
  const MELODY = [
    NOTE.C5,0,NOTE.E5,0,NOTE.G5,0,NOTE.A5,0, NOTE.G5,0,NOTE.E5,0,NOTE.D5,0,NOTE.C5,0,
    NOTE.E5,0,NOTE.G5,0,NOTE.C6,0,NOTE.A5,0, NOTE.G5,0,NOTE.E5,0,NOTE.D5,0,0,0,
    NOTE.C5,0,NOTE.D5,0,NOTE.E5,0,NOTE.G5,0, NOTE.A5,0,NOTE.G5,0,NOTE.E5,0,NOTE.D5,0,
    NOTE.C5,0,NOTE.E5,0,NOTE.D5,0,NOTE.C5,0, NOTE.A4,0,NOTE.G4,0,NOTE.C5,0,0,0,
  ];
  const BEAT = 0.46;

  function ensureCtx() {
    if (!ctx) {
      const AC = window.AudioContext || window.webkitAudioContext;
      if (!AC) return null;
      ctx = new AC();
      master = ctx.createGain();
      master.gain.value = 1;
      master.connect(ctx.destination);
      musicGain = ctx.createGain();
      musicGain.gain.value = 0;
      musicGain.connect(master);
    }
    if (ctx.state === 'suspended') ctx.resume();
    return ctx;
  }

  function tone(freq, delay, dur, type, vol, glideTo) {
    const c = ensureCtx();
    if (!c || !sfxOn) return;
    const t0 = c.currentTime + delay;
    const o = c.createOscillator();
    const g = c.createGain();
    o.type = type || 'sine';
    o.frequency.setValueAtTime(freq, t0);
    if (glideTo) o.frequency.exponentialRampToValueAtTime(glideTo, t0 + dur * 0.9);
    g.gain.setValueAtTime(0.0001, t0);
    g.gain.linearRampToValueAtTime(vol, t0 + 0.015);
    g.gain.exponentialRampToValueAtTime(0.0001, t0 + dur);
    o.connect(g);
    g.connect(master);
    o.start(t0);
    o.stop(t0 + dur + 0.05);
  }

  /* ---------- Efek suara ---------- */
  const sfx = {
    tap()    { tone(700, 0, 0.07, 'sine', 0.12); },
    pop()    { tone(320, 0, 0.13, 'sine', 0.22, 950); },
    ding(i)  { tone(560 + i * 55, 0, 0.22, 'triangle', 0.18); },
    correct() {
      [523.25, 659.25, 783.99, 1046.5].forEach((f, i) => tone(f, i * 0.09, 0.28, 'triangle', 0.2));
    },
    wrong() {
      tone(340, 0, 0.16, 'sine', 0.16);
      tone(260, 0.18, 0.22, 'sine', 0.16);
    },
    star() {
      [1046.5, 1318.5, 1568.0].forEach((f, i) => tone(f, i * 0.06, 0.15, 'sine', 0.13));
    },
    win() {
      [392, 523.25, 659.25, 783.99].forEach((f, i) => tone(f, i * 0.12, 0.25, 'triangle', 0.2));
      [523.25, 659.25, 783.99].forEach((f) => tone(f, 0.55, 0.7, 'triangle', 0.14));
    },
    applause() {
      const c = ensureCtx();
      if (!c || !sfxOn) return;
      for (let i = 0; i < 14; i++) {
        const t0 = c.currentTime + i * 0.09 + Math.random() * 0.04;
        const dur = 0.07;
        const buf = c.createBuffer(1, Math.floor(c.sampleRate * dur), c.sampleRate);
        const d = buf.getChannelData(0);
        for (let j = 0; j < d.length; j++) d[j] = (Math.random() * 2 - 1) * Math.pow(1 - j / d.length, 2);
        const src = c.createBufferSource();
        src.buffer = buf;
        const f = c.createBiquadFilter();
        f.type = 'bandpass';
        f.frequency.value = 1400 + Math.random() * 900;
        const g = c.createGain();
        g.gain.value = 0.12;
        src.connect(f); f.connect(g); g.connect(master);
        src.start(t0);
      }
    },
  };

  /* ---------- Narasi (Web Speech API, Bahasa Indonesia) ---------- */
  function initVoices() {
    if (!('speechSynthesis' in window)) return;
    const pick = () => {
      const vs = window.speechSynthesis.getVoices();
      idVoice =
        vs.find((v) => /^id([-_]|$)/i.test(v.lang)) ||
        vs.find((v) => /indonesia/i.test(v.name)) ||
        null;
    };
    pick();
    window.speechSynthesis.onvoiceschanged = pick;
  }

  function speak(text, opts = {}) {
    if (!sfxOn || !('speechSynthesis' in window)) return;
    if (opts.interrupt !== false) window.speechSynthesis.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.lang = 'id-ID';
    if (idVoice) u.voice = idVoice;
    u.rate = opts.rate || 0.88;
    u.pitch = opts.pitch || 1.05;
    window.speechSynthesis.speak(u);
  }

  function cancelSpeech() {
    if ('speechSynthesis' in window) window.speechSynthesis.cancel();
  }

  /* ---------- Musik latar ---------- */
  function playMusicNote(freq, time) {
    const c = ctx;
    const o = c.createOscillator();
    o.type = 'triangle';
    o.frequency.value = freq;
    const g = c.createGain();
    g.gain.setValueAtTime(0.0001, time);
    g.gain.linearRampToValueAtTime(0.5, time + 0.04);
    g.gain.exponentialRampToValueAtTime(0.0001, time + 0.8);
    o.connect(g);
    g.connect(musicGain);
    o.start(time);
    o.stop(time + 0.85);
  }

  function scheduler() {
    if (!ctx) return;
    while (nextNoteTime < ctx.currentTime + 0.35) {
      const f = MELODY[noteIndex % MELODY.length];
      if (f) playMusicNote(f, nextNoteTime);
      if (noteIndex % 8 === 0) {
        const bass = ((noteIndex / 8) % 2 === 0) ? 130.81 : 98.0;
        playMusicNote(bass, nextNoteTime);
      }
      nextNoteTime += BEAT;
      noteIndex++;
    }
  }

  function startMusic() {
    const c = ensureCtx();
    if (!c) return;
    musicGain.gain.cancelScheduledValues(c.currentTime);
    musicGain.gain.setTargetAtTime(0.055, c.currentTime, 0.3);
    if (musicTimer) return;
    nextNoteTime = c.currentTime + 0.1;
    noteIndex = 0;
    musicTimer = setInterval(scheduler, 150);
  }

  function stopMusic() {
    if (musicTimer) { clearInterval(musicTimer); musicTimer = null; }
    if (ctx) {
      musicGain.gain.cancelScheduledValues(ctx.currentTime);
      musicGain.gain.setTargetAtTime(0.0001, ctx.currentTime, 0.15);
    }
  }

  initVoices();

  return {
    init: ensureCtx,
    speak,
    cancelSpeech,
    startMusic,
    stopMusic,
    setSfx(on)   { sfxOn = on; if (!on) cancelSpeech(); return sfxOn; },
    setMusic(on) { musicOn = on; if (on) { if (ctx) startMusic(); } else stopMusic(); return musicOn; },
    isSfx: () => sfxOn,
    isMusic: () => musicOn,
    ...sfx,
  };
})();
