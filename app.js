let soundEnabled = true;
let currentDot = 1;
let previousDot = null;
let drawColor = 'red';
let drawing = false;

function playTone(frequency = 600, duration = 0.12) {
  if (!soundEnabled) return;

  try {
    const AudioContextClass =
      window.AudioContext ||
      window.webkitAudioContext;

    const audioContext =
      new AudioContextClass();

    const oscillator =
      audioContext.createOscillator();

    const gain =
      audioContext.createGain();

    oscillator.frequency.value =
      frequency;

    gain.gain.value = 0.08;

    oscillator.connect(gain);
    gain.connect(
      audioContext.destination
    );

    oscillator.start();

    gain.gain.exponentialRampToValueAtTime(
      0.001,
      audioContext.currentTime +
        duration
    );

    oscillator.stop(
      audioContext.currentTime +
        duration
    );
  } catch (error) {
    console.log(error);
  }
}

function speak(text) {
  playTone(700);

  if (!soundEnabled) return;

  if (
    'speechSynthesis' in window
  ) {
    speechSynthesis.cancel();

    const speech =
      new SpeechSynthesisUtterance(text);

    speech.lang = 'id-ID';
    speech.rate = 0.8;

    speechSynthesis.speak(speech);
  }
}

function toggleSound() {
  soundEnabled = !soundEnabled;

  const button =
    document.getElementById(
      'soundButton'
    );

  button.textContent =
    soundEnabled
      ? '🎵 ON'
      : '🔇 OFF';

  if (soundEnabled) {
    playTone(800);
  }
}

function openPage(pageId) {
  document
    .querySelectorAll('.page')
    .forEach(page => {
      page.classList.remove('active');
    });

  document
    .getElementById(pageId)
    .classList.add('active');

  playTone(650);
}

function goHome() {
  openPage('homePage');
}

function changeColor(
  color,
  name
) {
  const page =
    document.getElementById(
      'warnaPage'
    );

  const display =
    document.getElementById(
      'colorDisplay'
    );

  page.style.background = color;
  display.style.background = color;
  display.textContent =
    'INI WARNA ' +
    name.toUpperCase();

  speak(name);
  createEffect('🌈');
}

function createEffect(
  emoji
) {
  const layer =
    document.getElementById(
      'effectLayer'
    );

  for (
    let i = 0;
    i < 18;
    i++
  ) {
    const item =
      document.createElement('div');

    item.className = 'effect';
    item.textContent = emoji;

    item.style.left =
      50 + '%';

    item.style.top =
      45 + '%';

    item.style.setProperty(
      '--x',
      (
        Math.random() * 500 -
        250
      ) + 'px'
    );

    item.style.setProperty(
      '--y',
      (
        Math.random() * 500 -
        250
      ) + 'px'
    );

    layer.appendChild(item);

    setTimeout(() => {
      item.remove();
    }, 1600);
  }
}

function clickDot(
  number,
  element
) {
  if (
    number !== currentDot
  ) {
    playTone(200, 0.25);
    speak(
      'Coba cari nomor ' +
      currentDot
    );

    createEffect('😊');
    return;
  }

  element.classList.add('done');

  playTone(
    500 + number * 100
  );

  speak(String(number));

  if (previousDot) {
    drawLine(
      previousDot,
      element
    );
  }

  previousDot = element;
  currentDot++;

  if (currentDot <= 5) {
    document.getElementById(
      'dotInstruction'
    ).textContent =
      'Hubungkan titik nomor ' +
      currentDot;
  } else {
    document.getElementById(
      'dotInstruction'
    ).textContent =
      '🎉 HEBAT! GAMBAR SELESAI!';

    createEffect('⭐');
    speak(
      'Hebat! Kamu berhasil!'
    );
  }
}

function drawLine(
  from,
  to
) {
  const container =
    document.getElementById(
      'dotGame'
    );

  const svg =
    document.getElementById(
      'dotLines'
    );

  const containerRect =
    container.getBoundingClientRect();

  const a =
    from.getBoundingClientRect();

  const b =
    to.getBoundingClientRect();

  const x1 =
    a.left +
    a.width / 2 -
    containerRect.left;

  const y1 =
    a.top +
    a.height / 2 -
    containerRect.top;

  const x2 =
    b.left +
    b.width / 2 -
    containerRect.left;

  const y2 =
    b.top +
    b.height / 2 -
    containerRect.top;

  const line =
    document.createElementNS(
      'http://www.w3.org/2000/svg',
      'line'
    );

  line.setAttribute(
    'x1',
    x1
  );

  line.setAttribute(
    'y1',
    y1
  );

  line.setAttribute(
    'x2',
    x2
  );

  line.setAttribute(
    'y2',
    y2
  );

  line.setAttribute(
    'stroke',
    '#4caf50'
  );

  line.setAttribute(
    'stroke-width',
    '8'
  );

  line.setAttribute(
    'stroke-linecap',
    'round'
  );

  svg.appendChild(line);
}

function quizAnswer(correct) {
  const result =
    document.getElementById(
      'quizResult'
    );

  if (correct) {
    result.textContent =
      '🎉 BENAR! HEBAT SEKALI!';

    result.style.color =
      '#28a745';

    playTone(900, 0.2);
    createEffect('⭐');

    speak(
      'Benar! Hebat sekali!'
    );
  } else {
    result.textContent =
      '😊 Belum tepat. Coba lagi ya!';

    result.style.color =
      '#ff6b6b';

    playTone(220, 0.2);

    speak(
      'Belum tepat. Coba lagi ya!'
    );
  }
}

function setupCanvas() {
  const canvas =
    document.getElementById(
      'paintCanvas'
    );

  if (!canvas) return;

  const context =
    canvas.getContext('2d');

  function resize() {
    const rect =
      canvas.getBoundingClientRect();

    canvas.width =
      rect.width;

    canvas.height =
      rect.height;

    context.lineCap =
      'round';

    context.lineJoin =
      'round';

    context.lineWidth =
      12;
  }

  resize();

  window.addEventListener(
    'resize',
    resize
  );

  function position(event) {
    const rect =
      canvas.getBoundingClientRect();

    const point =
      event.touches
        ? event.touches[0]
        : event;

    return {
      x:
        point.clientX -
        rect.left,

      y:
        point.clientY -
        rect.top
    };
  }

  function start(event) {
    drawing = true;

    const point =
      position(event);

    context.beginPath();

    context.moveTo(
      point.x,
      point.y
    );

    event.preventDefault();
  }

  function move(event) {
    if (!drawing) return;

    const point =
      position(event);

    context.strokeStyle =
      drawColor;

    context.lineTo(
      point.x,
      point.y
    );

    context.stroke();

    event.preventDefault();
  }

  function end() {
    drawing = false;
    playTone(550);
  }

  canvas.addEventListener(
    'mousedown',
    start
  );

  canvas.addEventListener(
    'mousemove',
    move
  );

  window.addEventListener(
    'mouseup',
    end
  );

  canvas.addEventListener(
    'touchstart',
    start,
    { passive:false }
  );

  canvas.addEventListener(
    'touchmove',
    move,
    { passive:false }
  );

  canvas.addEventListener(
    'touchend',
    end
  );
}

function setDrawColor(color) {
  drawColor = color;
  playTone(700);
}

function clearCanvas() {
  const canvas =
    document.getElementById(
      'paintCanvas'
    );

  const context =
    canvas.getContext('2d');

  context.clearRect(
    0,
    0,
    canvas.width,
    canvas.height
  );

  playTone(400);
}

document.addEventListener(
  'DOMContentLoaded',
  setupCanvas
);
