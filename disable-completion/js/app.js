/* ===== Belajar TK — App utama ===== */
(() => {
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];
  const main = $('#main');

  const store = {
    get(k) { try { return localStorage.getItem(k); } catch (e) { return null; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch (e) {} },
  };

  const state = {
    screen: 'home', fresh: false,
    huruf: 0, angka: 0, hijaiyah: 0,
    gambarCat: 'hewan',
    picture: null,
    brush: PALETTE[0],
    quiz: null,
  };

  let navStack = [];
  let timers = [];
  const later = (fn, ms) => { const t = setTimeout(fn, ms); timers.push(t); return t; };
  const clearTimers = () => { timers.forEach(clearTimeout); timers = []; };

  const shuffle = (arr) => {
    const a = [...arr];
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  };
  const rand = (arr) => arr[Math.floor(Math.random() * arr.length)];
  const allGambarItems = () => Object.values(GAMBAR).flatMap((c) => c.items);

  /* ---------- util UI ---------- */
  function toast(msg) {
    const el = $('#toast');
    el.textContent = msg;
    el.classList.add('show');
    clearTimeout(el._t);
    el._t = setTimeout(() => el.classList.remove('show'), 1500);
  }

  function confetti(n = 26) {
    const layer = $('#confettiLayer');
    const colors = ['#FF8A80', '#FFD166', '#66D2A6', '#64C7F5', '#B69CFF', '#FF9EC7'];
    for (let i = 0; i < n; i++) {
      const p = document.createElement('div');
      p.className = 'confetti-piece';
      p.style.left = Math.random() * 100 + 'vw';
      p.style.background = colors[Math.floor(Math.random() * colors.length)];
      p.style.width = 8 + Math.random() * 6 + 'px';
      p.style.height = 10 + Math.random() * 8 + 'px';
      p.style.animationDuration = (1.4 + Math.random() * 1.2) + 's';
      p.style.animationDelay = (Math.random() * 0.25) + 's';
      layer.appendChild(p);
      setTimeout(() => p.remove(), 3200);
    }
  }

  function bounce(el) {
    if (!el) return;
    el.classList.remove('bounce-once');
    void el.offsetWidth;
    el.classList.add('bounce-once');
  }

  function ripple(x, y, color) {
    const r = document.createElement('div');
    r.className = 'ripple';
    r.style.left = x + 'px';
    r.style.top = y + 'px';
    r.style.background = color;
    document.body.appendChild(r);
    setTimeout(() => r.remove(), 900);
  }

  /* ---------- navigasi ---------- */
  function setTop(title, showBack) {
    $('#topTitle').textContent = title;
    $('#btnBack').style.visibility = showBack ? 'visible' : 'hidden';
  }

  function render(screen) {
    clearTimers();
    AudioEngine.cancelSpeech();
    $$('.focus-overlay').forEach((o) => o.remove());
    const views = {
      home: renderHome,
      huruf: renderHuruf, hurufDetail: renderHurufDetail,
      angka: renderAngka, angkaDetail: renderAngkaDetail,
      hijaiyah: renderHijaiyah,
      gambar: renderGambar,
      warna: renderWarna,
      mewarnai: renderMewarnai, mewarnaiWarna: renderMewarnaiWarna,
      kuis: renderKuisIntro, kuisSoal: renderKuisSoal, kuisHasil: renderKuisHasil,
    };
    (views[screen] || renderHome)();
    window.scrollTo(0, 0);
  }

  function show(screen) {
    if (state.screen === 'warna' && screen !== 'warna') resetBg();
    state.screen = screen;
    render(screen);
  }

  function go(screen) {
    if (screen === 'home') navStack = [];
    else navStack.push(state.screen);
    state.fresh = true;
    show(screen);
  }

  function back() {
    const prev = navStack.pop() || 'home';
    show(prev);
  }

  $('#btnBack').addEventListener('click', () => { AudioEngine.tap(); back(); });

  /* ---------- BERANDA ---------- */
  function renderHome() {
    setTop('Beranda', false);
    const mods = [
      { id: 'huruf',    icon: '🔤', label: 'Huruf ABC',  color: 'coral' },
      { id: 'angka',    icon: '🔢', label: 'Angka 1-10', color: 'sky' },
      { id: 'hijaiyah', icon: '🕌', label: 'Hijaiyah',    color: 'mint' },
      { id: 'gambar',   icon: '🖼️', label: 'Gambar',     color: 'sun' },
      { id: 'warna',    icon: '🎨', label: 'Warna',      color: 'lav' },
      { id: 'mewarnai', icon: '🖍️', label: 'Mewarnai',   color: 'pink' },
      { id: 'kuis',     icon: '🏆', label: 'Kuis',       color: 'grape' },
    ];
    main.innerHTML = `
      <div class="home-hero">
        <div class="mascot">🐼</div>
        <div>
          <h2>Halo, teman!</h2>
          <p>Mau belajar apa hari ini?</p>
        </div>
      </div>
      <div class="module-grid">
        ${mods.map((m, i) => `
          <button class="module-card c-${m.color}" data-go="${m.id}" style="animation-delay:${(i * 0.07).toFixed(2)}s">
            <span class="module-icon">${m.icon}</span>
            <span class="module-label">${m.label}</span>
          </button>`).join('')}
      </div>`;
    $$('.module-card', main).forEach((b) =>
      b.addEventListener('click', () => { AudioEngine.pop(); go(b.dataset.go); })
    );
  }

  /* ---------- HURUF ---------- */
  const LETTER_COLORS = ['#FF7A59', '#4DA6FF', '#3BB273', '#F5A623', '#B57BEE', '#F26D9D'];

  function renderHuruf() {
    setTop('Huruf ABC', true);
    main.innerHTML = `
      <p class="hint">👆 Tekan huruf untuk belajar</p>
      <div class="letter-grid">
        ${HURUF.map((h, i) =>
          `<button class="letter-cell" data-i="${i}" style="color:${LETTER_COLORS[i % LETTER_COLORS.length]}">${h.letter}</button>`
        ).join('')}
      </div>`;
    $$('.letter-cell', main).forEach((b) =>
      b.addEventListener('click', () => {
        AudioEngine.pop();
        state.huruf = +b.dataset.i;
        go('hurufDetail');
      })
    );
    later(() => AudioEngine.speak('Ayo belajar huruf ABC'), 300);
  }

  function renderHurufDetail() {
    const i = state.huruf;
    const h = HURUF[i];
    const col = LETTER_COLORS[i % LETTER_COLORS.length];
    setTop('Huruf ' + h.letter, true);
    main.innerHTML = `
      <div class="detail-nav">
        <button class="nav-btn" id="hPrev" aria-label="Sebelumnya">⬅️</button>
        <div class="big-card" id="hCard">
          <div class="big-letter" style="color:${col}">${h.letter}</div>
          <div class="word-row">
            <span class="word-emoji">${h.emoji}</span>
            <span class="word-text"><b>${h.letter}</b> untuk <b>${h.word}</b></span>
          </div>
          <button class="btn btn-small btn-primary" id="hSay">🔊 Dengar</button>
        </div>
        <button class="nav-btn" id="hNext" aria-label="Berikutnya">➡️</button>
      </div>
      <div class="counter">${i + 1} / ${HURUF.length}</div>`;
    const card = $('#hCard');
    const say = () => {
      AudioEngine.speak(`${h.letter}. ${h.letter} untuk ${h.word}`);
      bounce(card);
    };
    card.addEventListener('click', say);
    $('#hSay').addEventListener('click', (e) => { e.stopPropagation(); say(); });
    $('#hPrev').addEventListener('click', () => {
      AudioEngine.tap();
      state.huruf = (state.huruf - 1 + HURUF.length) % HURUF.length;
      show('hurufDetail');
    });
    $('#hNext').addEventListener('click', () => {
      AudioEngine.tap();
      state.huruf = (state.huruf + 1) % HURUF.length;
      show('hurufDetail');
    });
    later(say, 400);
  }

  /* ---------- ANGKA ---------- */
  function renderAngka() {
    setTop('Angka 1 - 10', true);
    main.innerHTML = `
      <p class="hint">👆 Tekan angka untuk berhitung</p>
      <div class="letter-grid">
        ${ANGKA.map((a, i) => `
          <button class="letter-cell num-cell" data-i="${i}">
            <span class="num-big">${a.n}</span>
            <span class="num-emoji">${a.emoji}</span>
          </button>`).join('')}
      </div>`;
    $$('.num-cell', main).forEach((b) =>
      b.addEventListener('click', () => {
        AudioEngine.pop();
        state.angka = +b.dataset.i;
        go('angkaDetail');
      })
    );
    later(() => AudioEngine.speak('Ayo belajar angka dan berhitung'), 300);
  }

  function startCount() {
    const row = $('#objRow');
    if (!row) return;
    row.innerHTML = '';
    const a = ANGKA[state.angka];
    AudioEngine.cancelSpeech();
    let i = 0;
    const step = () => {
      i++;
      const s = document.createElement('span');
      s.className = 'count-item';
      s.textContent = a.emoji;
      row.appendChild(s);
      AudioEngine.ding(i);
      AudioEngine.speak(NUM_WORDS[i - 1], { interrupt: false, rate: 0.95 });
      if (i < a.n) later(step, 800);
      else later(() => AudioEngine.speak(`Ada ${NUM_WORDS[a.n - 1]} ${a.name}`), 800);
    };
    step();
  }

  function renderAngkaDetail() {
    const i = state.angka;
    const a = ANGKA[i];
    setTop('Angka ' + a.n, true);
    main.innerHTML = `
      <div class="detail-nav">
        <button class="nav-btn" id="aPrev" aria-label="Sebelumnya">⬅️</button>
        <div class="big-card" id="aCard">
          <div class="big-number">${a.n}</div>
          <div class="obj-row" id="objRow"></div>
          <button class="btn btn-small btn-primary" id="aCount">🔢 Hitung Lagi</button>
        </div>
        <button class="nav-btn" id="aNext" aria-label="Berikutnya">➡️</button>
      </div>
      <div class="counter">${i + 1} / ${ANGKA.length}</div>`;
    $('#aCard').addEventListener('click', () => AudioEngine.speak(NUM_WORDS[a.n - 1]));
    $('#aCount').addEventListener('click', (e) => { e.stopPropagation(); AudioEngine.tap(); startCount(); });
    $('#aPrev').addEventListener('click', () => {
      AudioEngine.tap();
      state.angka = (state.angka - 1 + ANGKA.length) % ANGKA.length;
      show('angkaDetail');
    });
    $('#aNext').addEventListener('click', () => {
      AudioEngine.tap();
      state.angka = (state.angka + 1) % ANGKA.length;
      show('angkaDetail');
    });
    later(startCount, 600);
  }

  /* ---------- HIJAIYAH ---------- */
  function renderHijaiyah() {
    const i = state.hijaiyah;
    const h = HIJAIYAH[i];
    setTop('Huruf Hijaiyah', true);
    main.innerHTML = `
      <div class="detail-nav">
        <button class="nav-btn" id="jPrev" aria-label="Sebelumnya">⬅️</button>
        <div class="big-card" id="jCard">
          <div class="big-arabic arabic">${h.h}</div>
          <div class="hijaiyah-name">${h.name}</div>
          <button class="btn btn-small btn-primary" id="jSay">🔊 Dengar</button>
        </div>
        <button class="nav-btn" id="jNext" aria-label="Berikutnya">➡️</button>
      </div>
      <div class="counter">${i + 1} / ${HIJAIYAH.length}</div>`;
    const card = $('#jCard');
    const say = () => {
      AudioEngine.speak(h.name);
      bounce(card);
    };
    card.addEventListener('click', say);
    $('#jSay').addEventListener('click', (e) => { e.stopPropagation(); say(); });
    $('#jPrev').addEventListener('click', () => {
      AudioEngine.tap();
      state.hijaiyah = (state.hijaiyah - 1 + HIJAIYAH.length) % HIJAIYAH.length;
      show('hijaiyah');
    });
    $('#jNext').addEventListener('click', () => {
      AudioEngine.tap();
      state.hijaiyah = (state.hijaiyah + 1) % HIJAIYAH.length;
      show('hijaiyah');
    });
    if (state.fresh) {
      state.fresh = false;
      later(() => AudioEngine.speak(`Ayo belajar huruf hijaiyah. Ini huruf ${h.name}`), 300);
    } else {
      later(say, 300);
    }
  }

  /* ---------- GAMBAR ---------- */
  function renderGambar() {
    setTop('Belajar Gambar', true);
    const cat = GAMBAR[state.gambarCat];
    main.innerHTML = `
      <div class="tab-row">
        ${Object.entries(GAMBAR).map(([k, c]) =>
          `<button class="tab-btn ${k === state.gambarCat ? 'on' : ''}" data-cat="${k}">${c.icon} ${c.label}</button>`
        ).join('')}
      </div>
      <div class="pic-grid">
        ${cat.items.map((it, i) => `
          <button class="pic-card" data-i="${i}" style="animation-delay:${(i * 0.04).toFixed(2)}s">
            <span class="pic-emoji">${it.emoji}</span>
            <span class="pic-name">${it.name}</span>
          </button>`).join('')}
      </div>`;
    $$('.tab-btn', main).forEach((b) =>
      b.addEventListener('click', () => {
        AudioEngine.tap();
        state.gambarCat = b.dataset.cat;
        show('gambar');
      })
    );
    $$('.pic-card', main).forEach((b) =>
      b.addEventListener('click', () => {
        AudioEngine.pop();
        showFocus(cat.items[+b.dataset.i]);
      })
    );
    later(() => AudioEngine.speak('Ayo mengenal gambar. Pilih gambarnya'), 300);
  }

  function showFocus(it) {
    const ov = document.createElement('div');
    ov.className = 'focus-overlay';
    ov.innerHTML = `
      <div class="focus-card">
        <span class="focus-emoji">${it.emoji}</span>
        <div class="focus-name">${it.name}</div>
      </div>`;
    ov.addEventListener('click', () => { AudioEngine.tap(); ov.remove(); });
    document.body.appendChild(ov);
    AudioEngine.speak(it.name);
    bounce($('.focus-card', ov));
  }

  /* ---------- WARNA (latar ikut berubah warna) ---------- */
  function setBodyBg(hex) { document.body.style.backgroundColor = hex; }
  function resetBg() { document.body.style.backgroundColor = ''; }

  function renderWarna() {
    setTop('Belajar Warna', true);
    main.innerHTML = `
      <div class="color-preview">
        <div class="color-blob" id="colorBlob" style="background:#8ED1FF">👆</div>
        <div class="color-name-big" id="colorName">Tekan warna di bawah</div>
        <div class="hint" style="margin:6px 0 0">Latar belakang ikut berubah warna!</div>
      </div>
      <div class="swatch-grid">
        ${WARNA.map((c, i) =>
          `<button class="swatch" data-i="${i}" style="background:${c.hex}" aria-label="${c.name}"></button>`
        ).join('')}
      </div>`;
    $$('.swatch', main).forEach((b) =>
      b.addEventListener('click', (e) => {
        const c = WARNA[+b.dataset.i];
        AudioEngine.pop();
        ripple(e.clientX || window.innerWidth / 2, e.clientY || window.innerHeight / 2, c.hex);
        setBodyBg(c.hex);
        const blob = $('#colorBlob');
        blob.style.background = c.hex;
        blob.textContent = c.emoji;
        blob.style.animation = 'none';
        void blob.offsetWidth;
        blob.style.animation = '';
        $('#colorName').textContent = c.name;
        AudioEngine.speak(`${c.name}. Warna ${c.name}`);
      })
    );
    later(() => AudioEngine.speak('Ayo belajar warna. Tekan warnanya'), 300);
  }

  /* ---------- MEWARNAI ---------- */
  function renderMewarnai() {
    setTop('Mewarnai', true);
    main.innerHTML = `
      <p class="hint">👆 Pilih gambar yang mau diwarnai</p>
      <div class="gallery-grid">
        ${Object.entries(PICTURES).map(([id, p], i) => `
          <button class="gallery-card" data-id="${id}" style="animation-delay:${(i * 0.06).toFixed(2)}s">
            ${p.svg}
            <span class="gallery-name">${p.name}</span>
          </button>`).join('')}
      </div>`;
    $$('.gallery-card', main).forEach((b) =>
      b.addEventListener('click', () => {
        AudioEngine.pop();
        state.picture = b.dataset.id;
        go('mewarnaiWarna');
      })
    );
    later(() => AudioEngine.speak('Ayo mewarnai. Pilih gambarnya'), 300);
  }

  function renderMewarnaiWarna() {
    const pic = PICTURES[state.picture];
    setTop('Mewarnai: ' + pic.name, true);
    main.innerHTML = `
      <div class="canvas-card">
        <div id="svgWrap">${pic.svg}</div>
      </div>
      <p class="hint">Pilih warna, lalu tekan bagian gambar</p>
      <div class="palette">
        ${PALETTE.map((c, i) =>
          `<button class="pal ${c.hex === state.brush.hex ? 'on' : ''}" data-i="${i}" style="background:${c.hex}" aria-label="${c.name}"></button>`
        ).join('')}
      </div>
      <div class="tool-row">
        <button class="btn btn-small btn-ghost" id="btnReset">🧽 Hapus Warna</button>
        <button class="btn btn-small btn-ghost" id="btnGallery">🖼️ Ganti Gambar</button>
      </div>`;
    const svg = $('#svgWrap svg');
    svg.addEventListener('click', (e) => {
      const t = e.target;
      if (t.classList && t.classList.contains('region')) {
        t.style.fill = state.brush.hex;
        AudioEngine.pop();
      }
    });
    $$('.pal', main).forEach((b) =>
      b.addEventListener('click', () => {
        state.brush = PALETTE[+b.dataset.i];
        AudioEngine.tap();
        AudioEngine.speak(state.brush.name);
        $$('.pal', main).forEach((x) => x.classList.remove('on'));
        b.classList.add('on');
      })
    );
    $('#btnReset').addEventListener('click', () => {
      AudioEngine.tap();
      $$('.region', svg).forEach((r) => { r.style.fill = ''; });
      AudioEngine.speak('Gambar sudah bersih');
    });
    $('#btnGallery').addEventListener('click', () => { AudioEngine.tap(); back(); });
  }

  /* ---------- KUIS ---------- */
  function qPicture() {
    const items = shuffle(allGambarItems()).slice(0, 4);
    const target = items[0];
    return {
      promptText: `Mana yang ${target.name}?`,
      speak: `Mana yang ${target.name}?`,
      display: `<span class="q-mark">🔍</span>`,
      options: shuffle(items.map((it) => ({ html: `<span>${it.emoji}</span>`, correct: it === target }))),
    };
  }

  function qLetter() {
    const ls = shuffle(HURUF).slice(0, 4);
    const target = ls[0];
    return {
      promptText: 'Ini huruf apa?',
      speak: 'Ini huruf apa?',
      display: `<span class="q-letter">${target.letter}</span>`,
      options: shuffle(ls.map((l) => ({ html: l.letter, correct: l === target }))),
    };
  }

  function qNumber() {
    const n = 1 + Math.floor(Math.random() * 10);
    const item = rand(allGambarItems());
    const others = shuffle([...Array(10)].map((_, i) => i + 1).filter((x) => x !== n)).slice(0, 3);
    const nums = shuffle([n, ...others]);
    return {
      promptText: 'Ada berapa banyak?',
      speak: 'Hitung, ada berapa banyak?',
      display: Array(n).fill(`<span class="q-emoji">${item.emoji}</span>`).join(''),
      options: nums.map((x) => ({ html: x, correct: x === n })),
    };
  }

  function qColor() {
    const cs = shuffle(WARNA).slice(0, 4);
    const target = cs[0];
    return {
      promptText: 'Ini warna apa?',
      speak: 'Ini warna apa?',
      display: `<span class="q-blob" style="background:${target.hex}"></span>`,
      options: shuffle(cs.map((c) => ({ html: c.name, correct: c === target, cls: 'txt' }))),
    };
  }

  function qHijaiyah() {
    const hs = shuffle(HIJAIYAH).slice(0, 4);
    const target = hs[0];
    return {
      promptText: `Mana huruf ${target.name}?`,
      speak: `Mana huruf ${target.name}?`,
      display: `<span class="q-word">${target.name}</span>`,
      options: shuffle(hs.map((h) => ({ html: h.h, correct: h === target, cls: 'arabic-opt' }))),
    };
  }

  function buildQuiz(total = 10) {
    const gens = shuffle([qPicture, qLetter, qNumber, qColor, qHijaiyah]);
    const list = [];
    for (let i = 0; i < total; i++) list.push(gens[i % gens.length]());
    return { list, idx: 0, stars: 0, locked: false, tried: false };
  }

  function renderKuisIntro() {
    setTop('Kuis Pintar', true);
    main.innerHTML = `
      <div class="result-card">
        <div class="result-trophy">🏆</div>
        <div class="result-msg">Kuis Pintar!</div>
        <p class="result-sub">10 soal seru. Jawab dengan benar dan kumpulkan bintangnya! ⭐</p>
        <button class="btn btn-primary btn-xl" id="quizStart">▶ MULAI KUIS</button>
      </div>`;
    $('#quizStart').addEventListener('click', () => {
      AudioEngine.pop();
      state.quiz = buildQuiz(10);
      go('kuisSoal');
    });
    later(() => AudioEngine.speak('Ayo main kuis. Jawab pertanyaannya dan kumpulkan bintang'), 300);
  }

  function renderKuisSoal() {
    const q = state.quiz;
    const item = q.list[q.idx];
    q.locked = false;
    q.tried = false;
    setTop(`Soal ${q.idx + 1} dari ${q.list.length}`, true);
    main.innerHTML = `
      <div class="quiz-top">
        <div class="progress"><div class="progress-fill" style="width:${(q.idx / q.list.length) * 100}%"></div></div>
        <div class="star-count">⭐ ${q.stars}</div>
      </div>
      <div class="quiz-card">
        <div class="quiz-display">${item.display}</div>
        <div class="quiz-prompt">${item.promptText}</div>
      </div>
      <div class="quiz-options">
        ${item.options.map((o, i) =>
          `<button class="quiz-opt ${o.cls || ''}" data-i="${i}">${o.html}</button>`
        ).join('')}
      </div>`;
    later(() => AudioEngine.speak(item.speak), 350);
    $$('.quiz-opt', main).forEach((b) =>
      b.addEventListener('click', () => answerQuiz(b, item.options[+b.dataset.i]))
    );
  }

  function answerQuiz(btn, opt) {
    const q = state.quiz;
    if (!q || q.locked || btn.disabled) return;
    if (opt.correct) {
      q.locked = true;
      if (!q.tried) q.stars++;
      btn.classList.add('correct');
      $$('.quiz-opt', main).forEach((x) => { x.disabled = true; });
      const s = document.createElement('span');
      s.className = 'fly-star';
      s.textContent = '⭐';
      btn.appendChild(s);
      AudioEngine.correct();
      AudioEngine.star();
      AudioEngine.speak(rand(PRAISE));
      confetti(22);
      later(() => {
        q.idx++;
        if (q.idx >= q.list.length) show('kuisHasil');
        else show('kuisSoal');
      }, 1700);
    } else {
      q.tried = true;
      btn.disabled = true;
      btn.classList.add('wrong');
      AudioEngine.wrong();
      AudioEngine.speak(rand(RETRY));
    }
  }

  function renderKuisHasil() {
    const q = state.quiz;
    const s = q.stars;
    const total = q.list.length;
    setTop('Hasil Kuis', true);
    let msg, sub, speakMsg;
    if (s === total)      { msg = 'Luar biasa! 🎉'; sub = 'Semua jawaban benar. Kamu hebat sekali!'; speakMsg = 'Luar biasa! Kamu hebat sekali!'; }
    else if (s >= 7)      { msg = 'Hebat! 🌟';       sub = 'Kamu anak pintar!';                      speakMsg = 'Hebat! Kamu anak pintar!'; }
    else                  { msg = 'Bagus! 👍';       sub = 'Ayo belajar lagi supaya lebih banyak bintangnya!'; speakMsg = 'Bagus! Ayo belajar lagi ya!'; }
    main.innerHTML = `
      <div class="result-card">
        <div class="result-trophy">🏆</div>
        <div class="result-stars">${'⭐'.repeat(s)}${'☆'.repeat(total - s)}</div>
        <div class="result-msg">${msg}</div>
        <p class="result-sub">Kamu mendapat ${s} dari ${total} bintang</p>
        <div class="tool-row">
          <button class="btn btn-primary" id="quizAgain">🔁 Main Lagi</button>
          <button class="btn btn-ghost" id="quizHome">🏠 Beranda</button>
        </div>
      </div>`;
    $('#quizAgain').addEventListener('click', () => {
      AudioEngine.pop();
      state.quiz = buildQuiz(10);
      show('kuisSoal');
    });
    $('#quizHome').addEventListener('click', () => { AudioEngine.pop(); go('home'); });
    AudioEngine.win();
    later(() => AudioEngine.applause(), 400);
    confetti(50);
    later(() => AudioEngine.speak(`${speakMsg} Kamu mendapat ${s} dari ${total} bintang`), 1100);
  }

  /* ---------- Toggle suara & musik ---------- */
  function refreshToggles() {
    const bs = $('#btnSfx'), bm = $('#btnMusic');
    bs.textContent = AudioEngine.isSfx() ? '🔊' : '🔇';
    bs.classList.toggle('off', !AudioEngine.isSfx());
    bm.textContent = '🎵';
    bm.classList.toggle('off', !AudioEngine.isMusic());
  }

  $('#btnSfx').addEventListener('click', () => {
    const on = AudioEngine.setSfx(!AudioEngine.isSfx());
    store.set('irkop-tk-sfx', on ? '1' : '0');
    refreshToggles();
    if (on) AudioEngine.pop();
    toast(on ? 'Suara dinyalakan' : 'Suara dimatikan');
  });

  $('#btnMusic').addEventListener('click', () => {
    const on = AudioEngine.setMusic(!AudioEngine.isMusic());
    store.set('irkop-tk-music', on ? '1' : '0');
    refreshToggles();
    toast(on ? 'Musik dinyalakan' : 'Musik dimatikan');
  });

  /* ---------- Start aplikasi ---------- */
  if (store.get('irkop-tk-sfx') === '0') AudioEngine.setSfx(false);
  if (store.get('irkop-tk-music') === '0') AudioEngine.setMusic(false);
  refreshToggles();

  $('#btnStart').addEventListener('click', () => {
    AudioEngine.init();
    AudioEngine.pop();
    $('#splash').style.display = 'none';
    $('#app').hidden = false;
    render('home');
    later(() => AudioEngine.speak('Selamat datang di Belajar TK. Ayo bermain sambil belajar!'), 600);
    if (AudioEngine.isMusic()) AudioEngine.startMusic();
  });
})();
