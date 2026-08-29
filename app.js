/* ========================================================== */
/* GLOBAL */
/* ========================================================== */

let soundEnabled = true;
let musicEnabled = true;
let audioContext = null;
let musicTimer = null;

let paintColor = '#ff4d6d';
let paintCanvas = null;
let paintContext = null;
let painting = false;

let paintPictureIndex = 0;

let tracePoints = [];
let traceCurrent = 0;
let traceDragging = false;
let traceLastPosition = null;
let traceTempLine = null;

let quizScore = 0;
let quizStreak = 0;
let quizCount = 0;
let currentQuiz = null;


/* ========================================================== */
/* SCREEN */
/* ========================================================== */

function showScreen(id) {

  document
    .querySelectorAll('.screen')
    .forEach(screen => {
      screen.classList.remove('active');
    });

  document
    .getElementById(id)
    .classList.add('active');

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
}

function startAdventure() {

  showScreen('mapScreen');

  playClick();

  if (musicEnabled) {
    startBacksound();
  }
}

function openWorld(id) {

  playClick();

  showScreen(id);

  if (id === 'paintScreen') {
    setTimeout(() => {
      setupPaintCanvas();
      drawPaintPicture();
    }, 100);
  }

  if (id === 'traceScreen') {
    setTimeout(() => {
      resetTrace();
    }, 100);
  }

  if (
    id === 'quizScreen' &&
    !currentQuiz
  ) {
    nextQuiz();
  }
}

function backToMap() {
  playClick();
  showScreen('mapScreen');
}


/* ========================================================== */
/* AUDIO */
/* ========================================================== */

function getAudioContext() {

  if (!audioContext) {

    const AudioContextClass =
      window.AudioContext ||
      window.webkitAudioContext;

    audioContext =
      new AudioContextClass();
  }

  if (
    audioContext.state ===
    'suspended'
  ) {
    audioContext.resume();
  }

  return audioContext;
}

function tone(
  frequency = 600,
  duration = .12,
  type = 'sine',
  volume = .07
) {

  if (!soundEnabled) return;

  try {

    const ctx =
      getAudioContext();

    const oscillator =
      ctx.createOscillator();

    const gain =
      ctx.createGain();

    oscillator.type =
      type;

    oscillator.frequency.value =
      frequency;

    gain.gain.value =
      volume;

    oscillator.connect(gain);

    gain.connect(
      ctx.destination
    );

    oscillator.start();

    gain.gain.exponentialRampToValueAtTime(
      .001,
      ctx.currentTime +
      duration
    );

    oscillator.stop(
      ctx.currentTime +
      duration
    );

  } catch (error) {

    console.log(error);
  }
}

function playClick() {
  tone(620,.09,'sine',.06);
}

function playCorrect() {

  if (!soundEnabled) return;

  tone(620,.12);
  setTimeout(() => {
    tone(780,.14);
  },120);

  setTimeout(() => {
    tone(980,.22);
  },260);
}

function playWrong() {

  if (!soundEnabled) return;

  tone(260,.18,'triangle');

  setTimeout(() => {
    tone(210,.22,'triangle');
  },160);
}

function speak(text) {

  playClick();

  if (
    !soundEnabled ||
    !('speechSynthesis' in window)
  ) {
    return;
  }

  speechSynthesis.cancel();

  const speech =
    new SpeechSynthesisUtterance(text);

  speech.lang =
    'id-ID';

  speech.rate =
    .78;

  speech.pitch =
    1.15;

  speechSynthesis.speak(speech);
}


/* ========================================================== */
/* BACKSOUND */
/* ========================================================== */

function startBacksound() {

  stopBacksound();

  if (!musicEnabled) return;

  const notes = [
    523,
    659,
    784,
    659,
    587,
    698,
    880,
    698
  ];

  let noteIndex = 0;

  musicTimer =
    setInterval(() => {

      if (
        musicEnabled &&
        soundEnabled
      ) {

        tone(
          notes[noteIndex],
          .20,
          'sine',
          .018
        );

        noteIndex =
          (
            noteIndex + 1
          ) %
          notes.length;
      }

    },420);
}

function stopBacksound() {

  if (musicTimer) {

    clearInterval(
      musicTimer
    );

    musicTimer = null;
  }
}

function toggleSound() {

  soundEnabled =
    !soundEnabled;

  musicEnabled =
    soundEnabled;

  const button =
    document.getElementById(
      'soundButton'
    );

  button.textContent =
    soundEnabled
      ? '🎵'
      : '🔇';

  if (soundEnabled) {

    playClick();

    startBacksound();

  } else {

    stopBacksound();

    if (
      'speechSynthesis'
      in window
    ) {
      speechSynthesis.cancel();
    }
  }
}


/* ========================================================== */
/* EFFECT */
/* ========================================================== */

function createEffect(
  emoji = '⭐',
  count = 20
) {

  const layer =
    document.getElementById(
      'effectLayer'
    );

  for (
    let i = 0;
    i < count;
    i++
  ) {

    const item =
      document.createElement('div');

    item.className =
      'effect-item';

    item.textContent =
      emoji;

    item.style.setProperty(
      '--x',
      (
        Math.random() * 600 -
        300
      ) + 'px'
    );

    item.style.setProperty(
      '--y',
      (
        Math.random() * 600 -
        300
      ) + 'px'
    );

    layer.appendChild(item);

    setTimeout(() => {
      item.remove();
    },1500);
  }
}


/* ========================================================== */
/* HURUF */
/* ========================================================== */

const letters =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  .split('');

function setupLetters() {

  const grid =
    document.getElementById(
      'lettersGrid'
    );

  grid.innerHTML = '';

  letters.forEach(letter => {

    const button =
      document.createElement('button');

    button.textContent =
      letter;

    button.onclick =
      () => {

        document
          .querySelectorAll(
            '#lettersGrid button'
          )
          .forEach(item => {
            item.classList.remove(
              'selected'
            );
          });

        button.classList.add(
          'selected'
        );

        document
          .getElementById(
            'letterHero'
          )
          .textContent =
          letter;

        document
          .getElementById(
            'letterName'
          )
          .textContent =
          'Huruf ' +
          letter;

        speak(
          'Huruf ' +
          letter
        );
      };

    grid.appendChild(button);
  });
}


/* ========================================================== */
/* ANGKA */
/* ========================================================== */

const numbers = [
  ['1','Satu'],
  ['2','Dua'],
  ['3','Tiga'],
  ['4','Empat'],
  ['5','Lima'],
  ['6','Enam'],
  ['7','Tujuh'],
  ['8','Delapan'],
  ['9','Sembilan'],
  ['10','Sepuluh'],
  ['11','Sebelas'],
  ['12','Dua Belas'],
  ['13','Tiga Belas'],
  ['14','Empat Belas'],
  ['15','Lima Belas'],
  ['16','Enam Belas'],
  ['17','Tujuh Belas'],
  ['18','Delapan Belas'],
  ['19','Sembilan Belas'],
  ['20','Dua Puluh']
];

function setupNumbers() {

  const grid =
    document.getElementById(
      'numbersGrid'
    );

  grid.innerHTML = '';

  numbers.forEach(item => {

    const button =
      document.createElement('button');

    button.textContent =
      item[0];

    button.onclick =
      () => {

        document
          .querySelectorAll(
            '#numbersGrid button'
          )
          .forEach(button => {
            button.classList.remove(
              'selected'
            );
          });

        button.classList.add(
          'selected'
        );

        document
          .getElementById(
            'numberHero'
          )
          .textContent =
          item[0];

        document
          .getElementById(
            'numberName'
          )
          .textContent =
          item[1];

        speak(item[1]);
      };

    grid.appendChild(button);
  });
}


/* ========================================================== */
/* HIJAIYAH */
/* ========================================================== */

const hijaiyah = [
  ['ا','Alif'],
  ['ب','Ba'],
  ['ت','Ta'],
  ['ث','Tsa'],
  ['ج','Jim'],
  ['ح','Ha'],
  ['خ','Kho'],
  ['د','Dal'],
  ['ذ','Dzal'],
  ['ر','Ro'],
  ['ز','Zai'],
  ['س','Sin'],
  ['ش','Syin'],
  ['ص','Shod'],
  ['ض','Dhod'],
  ['ط','Tho'],
  ['ظ','Zho'],
  ['ع','Ain'],
  ['غ','Ghain'],
  ['ف','Fa'],
  ['ق','Qof'],
  ['ك','Kaf'],
  ['ل','Lam'],
  ['م','Mim'],
  ['ن','Nun'],
  ['و','Wawu'],
  ['ه','Ha'],
  ['ي','Ya']
];

function setupHijaiyah() {

  const grid =
    document.getElementById(
      'hijaiyahGrid'
    );

  grid.innerHTML = '';

  hijaiyah.forEach(item => {

    const button =
      document.createElement('button');

    button.textContent =
      item[0];

    button.onclick =
      () => {

        document
          .querySelectorAll(
            '#hijaiyahGrid button'
          )
          .forEach(button => {
            button.classList.remove(
              'selected'
            );
          });

        button.classList.add(
          'selected'
        );

        document
          .getElementById(
            'hijaiyahHero'
          )
          .textContent =
          item[0];

        document
          .getElementById(
            'hijaiyahName'
          )
          .textContent =
          item[1];

        speak(item[1]);
      };

    grid.appendChild(button);
  });
}


/* ========================================================== */
/* GAMBAR */
/* ========================================================== */

const pictures = [
  ['🐱','Kucing'],
  ['🐶','Anjing'],
  ['🐰','Kelinci'],
  ['🐼','Panda'],
  ['🦁','Singa'],
  ['🐯','Harimau'],
  ['🐘','Gajah'],
  ['🦒','Jerapah'],
  ['🐵','Monyet'],
  ['🐸','Katak'],
  ['🐟','Ikan'],
  ['🐳','Paus'],
  ['🦋','Kupu kupu'],
  ['🐝','Lebah'],
  ['🍎','Apel'],
  ['🍌','Pisang'],
  ['🍇','Anggur'],
  ['🍉','Semangka'],
  ['🍓','Stroberi'],
  ['🥕','Wortel'],
  ['🌽','Jagung'],
  ['🚗','Mobil'],
  ['🚌','Bus'],
  ['🚂','Kereta'],
  ['✈️','Pesawat'],
  ['🚀','Roket'],
  ['🏠','Rumah'],
  ['🌳','Pohon'],
  ['🌸','Bunga'],
  ['☀️','Matahari'],
  ['🌙','Bulan'],
  ['⭐','Bintang']
];

function setupPictures() {

  const grid =
    document.getElementById(
      'pictureGrid'
    );

  grid.innerHTML = '';

  pictures.forEach(item => {

    const button =
      document.createElement('button');

    button.className =
      'picture-card';

    button.innerHTML =
      '<span class="picture-emoji">' +
      item[0] +
      '</span>' +
      '<span>' +
      item[1] +
      '</span>';

    button.onclick =
      () => {

        createEffect(
          item[0],
          10
        );

        speak(
          item[1]
        );
      };

    grid.appendChild(button);
  });
}


/* ========================================================== */
/* WARNA */
/* ========================================================== */

const colors = [
  ['Merah','#ff4d6d','🍎'],
  ['Oranye','#ff9f1c','🍊'],
  ['Kuning','#ffe66d','☀️'],
  ['Hijau','#75d66b','🌳'],
  ['Biru','#4dabf7','🐳'],
  ['Ungu','#9b5de5','🍇'],
  ['Merah Muda','#ff9fcf','🌸'],
  ['Cokelat','#9c6b45','🐻'],
  ['Hitam','#343a40','🐼'],
  ['Putih','#ffffff','☁️'],
  ['Abu Abu','#b8bec5','🐘'],
  ['Emas','#ffd43b','⭐']
];

function setupColors() {

  const grid =
    document.getElementById(
      'colorsGrid'
    );

  grid.innerHTML = '';

  colors.forEach(item => {

    const button =
      document.createElement('button');

    button.className =
      'color-choice';

    button.textContent =
      item[0];

    button.style.background =
      item[1];

    if (
      item[0] ===
      'Hitam'
    ) {
      button.style.color =
        'white';
    }

    button.onclick =
      () => {

        const screen =
          document.getElementById(
            'colorsScreen'
          );

        const preview =
          document.getElementById(
            'colorPreview'
          );

        screen.style.background =
          item[1];

        preview.style.background =
          item[1];

        document
          .getElementById(
            'colorEmoji'
          )
          .textContent =
          item[2];

        document
          .getElementById(
            'colorName'
          )
          .textContent =
          item[0]
          .toUpperCase();

        createEffect(
          item[2],
          14
        );

        speak(
          item[0]
        );
      };

    grid.appendChild(button);
  });
}


/* ========================================================== */
/* MEWARNAI */
/* ========================================================== */

const paintPictures = [
  'cat',
  'flower',
  'house',
  'fish'
];

function setupPaintCanvas() {

  paintCanvas =
    document.getElementById(
      'paintCanvas'
    );

  if (!paintCanvas) return;

  const rect =
    paintCanvas
    .getBoundingClientRect();

  const ratio =
    window.devicePixelRatio ||
    1;

  paintCanvas.width =
    rect.width *
    ratio;

  paintCanvas.height =
    rect.height *
    ratio;

  paintContext =
    paintCanvas.getContext(
      '2d'
    );

  paintContext.setTransform(
    ratio,
    0,
    0,
    ratio,
    0,
    0
  );

  paintContext.lineCap =
    'round';

  paintContext.lineJoin =
    'round';

  paintContext.lineWidth =
    22;

  paintCanvas.onpointerdown =
    startPaint;

  paintCanvas.onpointermove =
    movePaint;

  paintCanvas.onpointerup =
    endPaint;

  paintCanvas.onpointerleave =
    endPaint;
}

function paintPosition(event) {

  const rect =
    paintCanvas
    .getBoundingClientRect();

  return {
    x:
      event.clientX -
      rect.left,

    y:
      event.clientY -
      rect.top
  };
}

function startPaint(event) {

  painting = true;

  paintCanvas.setPointerCapture(
    event.pointerId
  );

  const point =
    paintPosition(event);

  paintContext.beginPath();

  paintContext.moveTo(
    point.x,
    point.y
  );

  playClick();
}

function movePaint(event) {

  if (!painting) return;

  const point =
    paintPosition(event);

  paintContext.strokeStyle =
    paintColor;

  paintContext.lineTo(
    point.x,
    point.y
  );

  paintContext.stroke();
}

function endPaint() {

  if (!painting) return;

  painting = false;
}

function setPaintColor(color) {

  paintColor = color;

  playClick();

  createEffect(
    '🎨',
    7
  );
}

function clearPaintCanvas() {

  if (!paintContext) return;

  paintContext.clearRect(
    0,
    0,
    paintCanvas.width,
    paintCanvas.height
  );

  drawPaintPicture();

  playClick();
}

function changePaintPicture() {

  paintPictureIndex =
    (
      paintPictureIndex + 1
    ) %
    paintPictures.length;

  clearPaintCanvas();

  speak(
    'Gambar baru'
  );
}

function drawPaintPicture() {

  if (!paintContext) return;

  const width =
    paintCanvas
    .getBoundingClientRect()
    .width;

  const height =
    paintCanvas
    .getBoundingClientRect()
    .height;

  paintContext.clearRect(
    0,
    0,
    width,
    height
  );

  paintContext.strokeStyle =
    '#26334a';

  paintContext.lineWidth =
    7;

  const picture =
    paintPictures[
      paintPictureIndex
    ];

  if (
    picture === 'cat'
  ) {
    drawCat(width,height);
  }

  if (
    picture === 'flower'
  ) {
    drawFlower(width,height);
  }

  if (
    picture === 'house'
  ) {
    drawHouse(width,height);
  }

  if (
    picture === 'fish'
  ) {
    drawFish(width,height);
  }

  paintContext.lineWidth =
    22;
}

function drawCat(w,h) {

  const x = w / 2;
  const y = h / 2;

  paintContext.beginPath();

  paintContext.arc(
    x,
    y,
    100,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.moveTo(
    x - 75,
    y - 65
  );

  paintContext.lineTo(
    x - 100,
    y - 155
  );

  paintContext.lineTo(
    x - 25,
    y - 95
  );

  paintContext.moveTo(
    x + 75,
    y - 65
  );

  paintContext.lineTo(
    x + 100,
    y - 155
  );

  paintContext.lineTo(
    x + 25,
    y - 95
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.arc(
    x - 38,
    y - 10,
    8,
    0,
    Math.PI * 2
  );

  paintContext.arc(
    x + 38,
    y - 10,
    8,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.moveTo(
    x,
    y + 15
  );

  paintContext.lineTo(
    x,
    y + 30
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.moveTo(
    x - 65,
    y + 30
  );

  paintContext.lineTo(
    x - 20,
    y + 25
  );

  paintContext.moveTo(
    x + 65,
    y + 30
  );

  paintContext.lineTo(
    x + 20,
    y + 25
  );

  paintContext.stroke();
}

function drawFlower(w,h) {

  const x = w / 2;
  const y = h / 2;

  paintContext.beginPath();

  paintContext.moveTo(
    x,
    y + 70
  );

  paintContext.lineTo(
    x,
    h - 70
  );

  paintContext.stroke();

  for (
    let i = 0;
    i < 6;
    i++
  ) {

    const angle =
      i *
      Math.PI / 3;

    const px =
      x +
      Math.cos(angle) *
      70;

    const py =
      y +
      Math.sin(angle) *
      70;

    paintContext.beginPath();

    paintContext.arc(
      px,
      py,
      50,
      0,
      Math.PI * 2
    );

    paintContext.stroke();
  }

  paintContext.beginPath();

  paintContext.arc(
    x,
    y,
    45,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.ellipse(
    x - 35,
    y + 180,
    60,
    25,
    -.6,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.ellipse(
    x + 35,
    y + 260,
    60,
    25,
    .6,
    0,
    Math.PI * 2
  );

  paintContext.stroke();
}

function drawHouse(w,h) {

  const x =
    w / 2;

  const y =
    h / 2;

  paintContext.strokeRect(
    x - 130,
    y - 10,
    260,
    190
  );

  paintContext.beginPath();

  paintContext.moveTo(
    x - 165,
    y - 10
  );

  paintContext.lineTo(
    x,
    y - 150
  );

  paintContext.lineTo(
    x + 165,
    y - 10
  );

  paintContext.closePath();

  paintContext.stroke();

  paintContext.strokeRect(
    x - 35,
    y + 70,
    70,
    110
  );

  paintContext.strokeRect(
    x - 105,
    y + 25,
    55,
    55
  );

  paintContext.strokeRect(
    x + 50,
    y + 25,
    55,
    55
  );
}

function drawFish(w,h) {

  const x =
    w / 2;

  const y =
    h / 2;

  paintContext.beginPath();

  paintContext.ellipse(
    x,
    y,
    150,
    90,
    0,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.moveTo(
    x + 145,
    y
  );

  paintContext.lineTo(
    x + 240,
    y - 90
  );

  paintContext.lineTo(
    x + 240,
    y + 90
  );

  paintContext.closePath();

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.arc(
    x - 70,
    y - 20,
    12,
    0,
    Math.PI * 2
  );

  paintContext.stroke();

  paintContext.beginPath();

  paintContext.arc(
    x + 25,
    y + 15,
    35,
    -.5,
    1
  );

  paintContext.stroke();
}


/* ========================================================== */
/* TITIK GARIS - DRAG */
/* ========================================================== */

function getTraceShape() {

  return [
    {x:50,y:12,label:'1'},
    {x:78,y:35,label:'2'},
    {x:67,y:72,label:'3'},
    {x:33,y:72,label:'4'},
    {x:22,y:35,label:'5'}
  ];
}

function resetTrace() {

  tracePoints =
    getTraceShape();

  traceCurrent = 0;
  traceDragging = false;
  traceLastPosition = null;

  const dots =
    document.getElementById(
      'traceDots'
    );

  const svg =
    document.getElementById(
      'traceSvg'
    );

  dots.innerHTML = '';
  svg.innerHTML = '';

  document
    .getElementById(
      'traceInstruction'
    )
    .textContent =
    '👉 Tahan titik 1 lalu tarik ke titik 2';

  tracePoints.forEach(
    (point,index) => {

      const dot =
        document.createElement(
          'button'
        );

      dot.className =
        'trace-dot' +
        (
          index === 0
            ? ' current'
            : ''
        );

      dot.textContent =
        point.label;

      dot.style.left =
        point.x + '%';

      dot.style.top =
        point.y + '%';

      dot.dataset.index =
        index;

      dot.addEventListener(
        'pointerdown',
        tracePointerDown
      );

      dots.appendChild(dot);
    }
  );

  const board =
    document.getElementById(
      'traceBoard'
    );

  board.onpointermove =
    tracePointerMove;

  board.onpointerup =
    tracePointerUp;

  board.onpointercancel =
    tracePointerUp;
}

function tracePointerDown(event) {

  const index =
    Number(
      event.currentTarget
      .dataset
      .index
    );

  if (
    index !==
    traceCurrent
  ) {

    playWrong();

    speak(
      'Ikuti urutan nomor ' +
      (
        traceCurrent + 1
      )
    );

    return;
  }

  traceDragging = true;

  traceLastPosition =
    tracePoints[index];

  event.currentTarget
    .setPointerCapture(
      event.pointerId
    );

  playClick();
}

function tracePointerMove(event) {

  if (!traceDragging) return;

  const board =
    document.getElementById(
      'traceBoard'
    );

  const rect =
    board.getBoundingClientRect();

  const x =
    (
      event.clientX -
      rect.left
    ) /
    rect.width *
    100;

  const y =
    (
      event.clientY -
      rect.top
    ) /
    rect.height *
    100;

  drawTempTrace(
    traceLastPosition,
    {x,y}
  );

  const nextIndex =
    traceCurrent + 1;

  if (
    nextIndex >=
    tracePoints.length
  ) {
    return;
  }

  const next =
    tracePoints[nextIndex];

  const dx =
    x - next.x;

  const dy =
    y - next.y;

  const distance =
    Math.sqrt(
      dx * dx +
      dy * dy
    );

  if (
    distance < 9
  ) {

    lockTraceLine(
      traceLastPosition,
      next
    );

    const currentDot =
      document.querySelector(
        '.trace-dot[data-index="' +
        traceCurrent +
        '"]'
      );

    currentDot.classList.remove(
      'current'
    );

    currentDot.classList.add(
      'done'
    );

    traceCurrent++;

    traceLastPosition =
      next;

    const nextDot =
      document.querySelector(
        '.trace-dot[data-index="' +
        traceCurrent +
        '"]'
      );

    if (nextDot) {

      nextDot.classList.add(
        'current'
      );
    }

    removeTempTrace();

    playClick();

    if (
      traceCurrent ===
      tracePoints.length - 1
    ) {

      document
        .getElementById(
          'traceInstruction'
        )
        .textContent =
        '🎉 Selesaikan dengan menarik ke titik terakhir!';

    } else {

      document
        .getElementById(
          'traceInstruction'
        )
        .textContent =
        '👉 Sekarang tarik ke titik ' +
        (
          traceCurrent + 1
        );
    }
  }
}

function tracePointerUp() {

  if (!traceDragging) return;

  traceDragging = false;

  removeTempTrace();

  if (
    traceCurrent ===
    tracePoints.length - 1
  ) {

    const finalDot =
      document.querySelector(
        '.trace-dot[data-index="' +
        traceCurrent +
        '"]'
      );

    if (
      finalDot &&
      !finalDot.classList.contains(
        'done'
      )
    ) {

      finalDot.classList.remove(
        'current'
      );

      finalDot.classList.add(
        'done'
      );

      createEffect(
        '⭐',
        30
      );

      playCorrect();

      speak(
        'Hebat! Kamu berhasil menyelesaikan gambar!'
      );

      document
        .getElementById(
          'traceInstruction'
        )
        .textContent =
        '🎉 HEBAT! GAMBAR SELESAI!';
    }
  }
}

function drawTempTrace(
  from,
  to
) {

  removeTempTrace();

  const svg =
    document.getElementById(
      'traceSvg'
    );

  traceTempLine =
    document.createElementNS(
      'http://www.w3.org/2000/svg',
      'line'
    );

  traceTempLine.setAttribute(
    'x1',
    from.x + '%'
  );

  traceTempLine.setAttribute(
    'y1',
    from.y + '%'
  );

  traceTempLine.setAttribute(
    'x2',
    to.x + '%'
  );

  traceTempLine.setAttribute(
    'y2',
    to.y + '%'
  );

  traceTempLine.setAttribute(
    'stroke',
    '#ff9f1c'
  );

  traceTempLine.setAttribute(
    'stroke-width',
    '8'
  );

  traceTempLine.setAttribute(
    'stroke-linecap',
    'round'
  );

  svg.appendChild(
    traceTempLine
  );
}

function removeTempTrace() {

  if (traceTempLine) {

    traceTempLine.remove();

    traceTempLine = null;
  }
}

function lockTraceLine(
  from,
  to
) {

  const svg =
    document.getElementById(
      'traceSvg'
    );

  const line =
    document.createElementNS(
      'http://www.w3.org/2000/svg',
      'line'
    );

  line.setAttribute(
    'x1',
    from.x + '%'
  );

  line.setAttribute(
    'y1',
    from.y + '%'
  );

  line.setAttribute(
    'x2',
    to.x + '%'
  );

  line.setAttribute(
    'y2',
    to.y + '%'
  );

  line.setAttribute(
    'stroke',
    '#42c96b'
  );

  line.setAttribute(
    'stroke-width',
    '9'
  );

  line.setAttribute(
    'stroke-linecap',
    'round'
  );

  svg.appendChild(line);
}


/* ========================================================== */
/* QUIZ UNLIMITED */
/* ========================================================== */

const quizBank = [

  {
    type:'picture',
    question:'Mana gambar Kucing?',
    correct:'🐱',
    options:['🐱','🐶','🐟','🦁']
  },

  {
    type:'picture',
    question:'Mana gambar Apel?',
    correct:'🍎',
    options:['🍎','🍌','🍇','🍉']
  },

  {
    type:'picture',
    question:'Mana gambar Mobil?',
    correct:'🚗',
    options:['🚗','✈️','🚀','🚂']
  },

  {
    type:'picture',
    question:'Mana gambar Gajah?',
    correct:'🐘',
    options:['🐘','🐵','🐯','🐶']
  },

  {
    type:'letter',
    question:'Mana huruf A?',
    correct:'A',
    options:['A','B','D','E']
  },

  {
    type:'letter',
    question:'Mana huruf M?',
    correct:'M',
    options:['M','N','W','H']
  },

  {
    type:'number',
    question:'Mana angka 5?',
    correct:'5',
    options:['3','5','7','9']
  },

  {
    type:'number',
    question:'Mana angka 10?',
    correct:'10',
    options:['8','6','10','12']
  },

  {
    type:'color',
    question:'Pilih warna Merah!',
    correct:'Merah',
    options:['Merah','Biru','Hijau','Kuning']
  },

  {
    type:'color',
    question:'Pilih warna Biru!',
    correct:'Biru',
    options:['Kuning','Merah','Biru','Hijau']
  }

];

function shuffle(array) {

  const result =
    [...array];

  for (
    let i =
      result.length - 1;
    i > 0;
    i--
  ) {

    const j =
      Math.floor(
        Math.random() *
        (i + 1)
      );

    [
      result[i],
      result[j]
    ] =
    [
      result[j],
      result[i]
    ];
  }

  return result;
}

function nextQuiz() {

  quizCount++;

  const generated =
    generateQuiz();

  currentQuiz =
    generated;

  document
    .getElementById(
      'quizQuestion'
    )
    .textContent =
    generated.question;

  document
    .getElementById(
      'quizCounter'
    )
    .textContent =
    'Pertanyaan ' +
    quizCount;

  document
    .getElementById(
      'quizFeedback'
    )
    .textContent =
    '';

  document
    .getElementById(
      'nextQuizButton'
    )
    .style.display =
    'none';

  const options =
    document.getElementById(
      'quizOptions'
    );

  options.innerHTML =
    '';

  shuffle(
    generated.options
  ).forEach(option => {

    const button =
      document.createElement(
        'button'
      );

    button.className =
      'quiz-option';

    button.textContent =
      option;

    button.onclick =
      () => answerQuiz(
        option
      );

    options.appendChild(
      button
    );
  });
}

function generateQuiz() {

  const mode =
    Math.floor(
      Math.random() * 5
    );

  if (mode === 0) {

    const item =
      pictures[
        Math.floor(
          Math.random() *
          pictures.length
        )
      ];

    const wrong =
      shuffle(
        pictures
        .filter(
          picture =>
          picture[1] !==
          item[1]
        )
      )
      .slice(0,3)
      .map(
        picture =>
        picture[0]
      );

    return {
      question:
        'Mana gambar ' +
        item[1] +
        '?',

      correct:
        item[0],

      options:
        [
          item[0],
          ...wrong
        ]
    };
  }

  if (mode === 1) {

    const letter =
      letters[
        Math.floor(
          Math.random() *
          letters.length
        )
      ];

    const wrong =
      shuffle(
        letters.filter(
          item =>
          item !== letter
        )
      )
      .slice(0,3);

    return {
      question:
        'Mana huruf ' +
        letter +
        '?',

      correct:
        letter,

      options:
        [
          letter,
          ...wrong
        ]
    };
  }

  if (mode === 2) {

    const item =
      numbers[
        Math.floor(
          Math.random() *
          10
        )
      ];

    const wrong =
      shuffle(
        numbers
        .slice(0,10)
        .filter(
          number =>
          number[0] !==
          item[0]
        )
      )
      .slice(0,3)
      .map(
        number =>
        number[0]
      );

    return {
      question:
        'Mana angka ' +
        item[0] +
        '?',

      correct:
        item[0],

      options:
        [
          item[0],
          ...wrong
        ]
    };
  }

  if (mode === 3) {

    const item =
      colors[
        Math.floor(
          Math.random() *
          colors.length
        )
      ];

    const wrong =
      shuffle(
        colors
        .filter(
          color =>
          color[0] !==
          item[0]
        )
      )
      .slice(0,3)
      .map(
        color =>
        color[0]
      );

    return {
      question:
        'Pilih warna ' +
        item[0] +
        '!',

      correct:
        item[0],

      options:
        [
          item[0],
          ...wrong
        ]
    };
  }

  const item =
    quizBank[
      Math.floor(
        Math.random() *
        quizBank.length
      )
    ];

  return {
    question:
      item.question,

    correct:
      item.correct,

    options:
      item.options
  };
}

function answerQuiz(answer) {

  if (
    !currentQuiz
  ) return;

  const feedback =
    document.getElementById(
      'quizFeedback'
    );

  const buttons =
    document.querySelectorAll(
      '.quiz-option'
    );

  if (
    answer ===
    currentQuiz.correct
  ) {

    buttons.forEach(
      button => {
        button.disabled = true;
      }
    );

    quizScore++;
    quizStreak++;

    document
      .getElementById(
        'quizScore'
      )
      .textContent =
      quizScore;

    document
      .getElementById(
        'quizStreak'
      )
      .textContent =
      quizStreak;

    feedback.textContent =
      '🎉 BENAR! HEBAT SEKALI!';

    feedback.style.color =
      '#28a745';

    playCorrect();

    createEffect(
      '⭐',
      32
    );

    speak(
      'Benar! Hebat sekali!'
    );

    document
      .getElementById(
        'nextQuizButton'
      )
      .style.display =
      'inline-block';

  } else {

    quizStreak = 0;

    document
      .getElementById(
        'quizStreak'
      )
      .textContent =
      quizStreak;

    feedback.textContent =
      '😊 Belum tepat, coba lagi ya!';

    feedback.style.color =
      '#e63946';

    playWrong();

    createEffect(
      '💫',
      10
    );

    speak(
      'Belum tepat. Coba lagi ya.'
    );
  }
}


/* ========================================================== */
/* INIT */
/* ========================================================== */

document.addEventListener(
  'DOMContentLoaded',
  () => {

    setupLetters();
    setupNumbers();
    setupHijaiyah();
    setupPictures();
    setupColors();

  }
);
