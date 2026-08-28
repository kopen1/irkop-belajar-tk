/* ===== Data konten Belajar TK ===== */

const HURUF = [
  { letter: 'A', word: 'Apel',    emoji: '🍎' },
  { letter: 'B', word: 'Bola',    emoji: '⚽' },
  { letter: 'C', word: 'Cicak',   emoji: '🦎' },
  { letter: 'D', word: 'Domba',   emoji: '🐑' },
  { letter: 'E', word: 'Es krim', emoji: '🍦' },
  { letter: 'F', word: 'Foto',    emoji: '📷' },
  { letter: 'G', word: 'Gajah',   emoji: '🐘' },
  { letter: 'H', word: 'Harimau', emoji: '🐯' },
  { letter: 'I', word: 'Ikan',    emoji: '🐟' },
  { letter: 'J', word: 'Jeruk',   emoji: '🍊' },
  { letter: 'K', word: 'Kucing',  emoji: '🐱' },
  { letter: 'L', word: 'Lampu',   emoji: '💡' },
  { letter: 'M', word: 'Mobil',   emoji: '🚗' },
  { letter: 'N', word: 'Nanas',   emoji: '🍍' },
  { letter: 'O', word: 'Ombak',   emoji: '🌊' },
  { letter: 'P', word: 'Pisang',  emoji: '🍌' },
  { letter: 'Q', word: 'Quran',   emoji: '📖' },
  { letter: 'R', word: 'Rumah',   emoji: '🏠' },
  { letter: 'S', word: 'Sepatu',  emoji: '👟' },
  { letter: 'T', word: 'Tas',     emoji: '🎒' },
  { letter: 'U', word: 'Ular',    emoji: '🐍' },
  { letter: 'V', word: 'Vas',     emoji: '🏺' },
  { letter: 'W', word: 'Wortel',  emoji: '🥕' },
  { letter: 'X', word: 'Xilofon', emoji: '🎼' },
  { letter: 'Y', word: 'Yoyo',    emoji: '🪀' },
  { letter: 'Z', word: 'Zebra',   emoji: '🦓' },
];

const NUM_WORDS = ['satu','dua','tiga','empat','lima','enam','tujuh','delapan','sembilan','sepuluh'];

const ANGKA = [
  { n: 1,  name: 'bintang',  emoji: '⭐' },
  { n: 2,  name: 'apel',     emoji: '🍎' },
  { n: 3,  name: 'balon',    emoji: '🎈' },
  { n: 4,  name: 'ikan',     emoji: '🐟' },
  { n: 5,  name: 'bunga',    emoji: '🌸' },
  { n: 6,  name: 'mobil',    emoji: '🚗' },
  { n: 7,  name: 'stroberi', emoji: '🍓' },
  { n: 8,  name: 'bola',     emoji: '⚽' },
  { n: 9,  name: 'permen',   emoji: '🍬' },
  { n: 10, name: 'hadiah',   emoji: '🎁' },
];

const HIJAIYAH = [
  { h: 'ا', name: 'Alif' },
  { h: 'ب', name: 'Ba' },
  { h: 'ت', name: 'Ta' },
  { h: 'ث', name: 'Tsa' },
  { h: 'ج', name: 'Jim' },
  { h: 'ح', name: 'Ha' },
  { h: 'خ', name: 'Kha' },
  { h: 'د', name: 'Dal' },
  { h: 'ذ', name: 'Dzal' },
  { h: 'ر', name: 'Ra' },
  { h: 'ز', name: 'Zai' },
  { h: 'س', name: 'Sin' },
  { h: 'ش', name: 'Syin' },
  { h: 'ص', name: 'Shad' },
  { h: 'ض', name: 'Dhad' },
  { h: 'ط', name: 'Tha' },
  { h: 'ظ', name: 'Zha' },
  { h: 'ع', name: 'Ain' },
  { h: 'غ', name: 'Ghain' },
  { h: 'ف', name: 'Fa' },
  { h: 'ق', name: 'Qaf' },
  { h: 'ك', name: 'Kaf' },
  { h: 'ل', name: 'Lam' },
  { h: 'م', name: 'Mim' },
  { h: 'ن', name: 'Nun' },
  { h: 'و', name: 'Wau' },
  { h: 'ه', name: 'Ha' },
  { h: 'ء', name: 'Hamzah' },
  { h: 'ي', name: 'Ya' },
];

const GAMBAR = {
  hewan: { label: 'Hewan', icon: '🐾', items: [
    { name: 'Kucing', emoji: '🐱' }, { name: 'Anjing', emoji: '🐶' },
    { name: 'Sapi', emoji: '🐮' }, { name: 'Ayam', emoji: '🐔' },
    { name: 'Bebek', emoji: '🦆' }, { name: 'Gajah', emoji: '🐘' },
    { name: 'Monyet', emoji: '🐵' }, { name: 'Ikan', emoji: '🐟' },
    { name: 'Burung', emoji: '🐦' }, { name: 'Kupu-kupu', emoji: '🦋' },
    { name: 'Kambing', emoji: '🐐' }, { name: 'Kuda', emoji: '🐴' },
  ]},
  buah: { label: 'Buah', icon: '🍎', items: [
    { name: 'Apel', emoji: '🍎' }, { name: 'Jeruk', emoji: '🍊' },
    { name: 'Pisang', emoji: '🍌' }, { name: 'Semangka', emoji: '🍉' },
    { name: 'Anggur', emoji: '🍇' }, { name: 'Stroberi', emoji: '🍓' },
    { name: 'Nanas', emoji: '🍍' }, { name: 'Mangga', emoji: '🥭' },
  ]},
  kendaraan: { label: 'Kendaraan', icon: '🚗', items: [
    { name: 'Mobil', emoji: '🚗' }, { name: 'Motor', emoji: '🏍️' },
    { name: 'Bus', emoji: '🚌' }, { name: 'Kapal', emoji: '⛵' },
    { name: 'Pesawat', emoji: '✈️' }, { name: 'Kereta', emoji: '🚂' },
    { name: 'Sepeda', emoji: '🚲' }, { name: 'Ambulans', emoji: '🚑' },
  ]},
  benda: { label: 'Benda', icon: '🎒', items: [
    { name: 'Buku', emoji: '📖' }, { name: 'Pensil', emoji: '✏️' },
    { name: 'Bola', emoji: '⚽' }, { name: 'Balon', emoji: '🎈' },
    { name: 'Payung', emoji: '☂️' }, { name: 'Jam', emoji: '⏰' },
    { name: 'Lampu', emoji: '💡' }, { name: 'Topi', emoji: '👒' },
  ]},
};

const WARNA = [
  { name: 'Merah',  hex: '#E84A4A', emoji: '🍎' },
  { name: 'Biru',   hex: '#4A7DE8', emoji: '🐳' },
  { name: 'Kuning', hex: '#F7D046', emoji: '🍋' },
  { name: 'Hijau',  hex: '#4CAF50', emoji: '🐸' },
  { name: 'Oranye', hex: '#F79646', emoji: '🍊' },
  { name: 'Ungu',   hex: '#9B59B6', emoji: '🍇' },
  { name: 'Pink',   hex: '#F06292', emoji: '🌸' },
  { name: 'Coklat', hex: '#8D6E63', emoji: '🐻' },
  { name: 'Hitam',  hex: '#3B4148', emoji: '🖤' },
  { name: 'Putih',  hex: '#FFFFFF', emoji: '☁️' },
];

const PALETTE = [
  { name: 'Merah',  hex: '#E84A4A' },
  { name: 'Oranye', hex: '#F79646' },
  { name: 'Kuning', hex: '#F7D046' },
  { name: 'Hijau',  hex: '#4CAF50' },
  { name: 'Biru',   hex: '#4A7DE8' },
  { name: 'Ungu',   hex: '#9B59B6' },
  { name: 'Pink',   hex: '#F06292' },
  { name: 'Coklat', hex: '#8D6E63' },
  { name: 'Hitam',  hex: '#3B4148' },
  { name: 'Putih',  hex: '#FFFFFF' },
];

const PRAISE = ['Hebat!', 'Betul sekali!', 'Pintar!', 'Keren!', 'Bagus sekali!'];
const RETRY  = ['Ayo coba lagi', 'Coba lagi ya', 'Hampir benar, coba lagi'];

/* ===== Gambar mewarnai (SVG) ===== */
const SVG_OPEN  = '<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" role="img">';
const SVG_CLOSE = '</svg>';

const PICTURES = {
  rumah: { name: 'Rumah', svg: SVG_OPEN + `
    <circle class="region" cx="165" cy="36" r="22"/>
    <ellipse class="region" cx="45" cy="32" rx="26" ry="14"/>
    <rect class="region" x="45" y="85" width="110" height="85" rx="4"/>
    <polygon class="region" points="100,14 175,86 25,86"/>
    <rect class="region" x="85" y="122" width="30" height="48" rx="3"/>
    <rect class="region" x="57" y="100" width="26" height="26" rx="3"/>
    <rect class="region" x="117" y="100" width="26" height="26" rx="3"/>
  ` + SVG_CLOSE },
  ikan: { name: 'Ikan', svg: SVG_OPEN + `
    <circle class="region" cx="168" cy="42" r="7"/>
    <circle class="region" cx="183" cy="58" r="5"/>
    <polygon class="region" points="138,100 186,66 186,134"/>
    <polygon class="region" points="72,66 94,38 112,66"/>
    <polygon class="region" points="76,136 92,160 108,134"/>
    <ellipse class="region" cx="90" cy="100" rx="56" ry="36"/>
    <circle class="region" cx="56" cy="90" r="7"/>
  ` + SVG_CLOSE },
  bunga: { name: 'Bunga', svg: SVG_OPEN + `
    <rect class="region" x="95" y="96" width="10" height="90" rx="5"/>
    <ellipse class="region" cx="70" cy="150" rx="22" ry="10" transform="rotate(-30 70 150)"/>
    <ellipse class="region" cx="130" cy="138" rx="22" ry="10" transform="rotate(30 130 138)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(0 100 80)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(60 100 80)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(120 100 80)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(180 100 80)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(240 100 80)"/>
    <ellipse class="region" cx="100" cy="48" rx="15" ry="26" transform="rotate(300 100 80)"/>
    <circle class="region" cx="100" cy="80" r="17"/>
  ` + SVG_CLOSE },
  mobil: { name: 'Mobil', svg: SVG_OPEN + `
    <rect class="region" x="15" y="95" width="170" height="45" rx="14"/>
    <rect class="region" x="45" y="60" width="110" height="45" rx="16"/>
    <rect class="region" x="55" y="68" width="42" height="30" rx="6"/>
    <rect class="region" x="103" y="68" width="42" height="30" rx="6"/>
    <circle class="region" cx="55" cy="142" r="20"/>
    <circle class="region" cx="55" cy="142" r="9"/>
    <circle class="region" cx="145" cy="142" r="20"/>
    <circle class="region" cx="145" cy="142" r="9"/>
    <circle class="region" cx="179" cy="108" r="6"/>
  ` + SVG_CLOSE },
  kupu: { name: 'Kupu-kupu', svg: SVG_OPEN + `
    <ellipse class="region" cx="60" cy="72" rx="38" ry="32" transform="rotate(-18 60 72)"/>
    <ellipse class="region" cx="140" cy="72" rx="38" ry="32" transform="rotate(18 140 72)"/>
    <ellipse class="region" cx="70" cy="130" rx="27" ry="25" transform="rotate(18 70 130)"/>
    <ellipse class="region" cx="130" cy="130" rx="27" ry="25" transform="rotate(-18 130 130)"/>
    <ellipse class="region" cx="100" cy="102" rx="10" ry="46"/>
    <circle class="region" cx="100" cy="50" r="12"/>
    <path class="deco" d="M94,40 Q84,20 74,14"/>
    <path class="deco" d="M106,40 Q116,20 126,14"/>
  ` + SVG_CLOSE },
  pohon: { name: 'Pohon', svg: SVG_OPEN + `
    <ellipse class="region" cx="100" cy="184" rx="72" ry="12"/>
    <rect class="region" x="88" y="112" width="24" height="70" rx="8"/>
    <circle class="region" cx="64" cy="94" r="28"/>
    <circle class="region" cx="136" cy="94" r="28"/>
    <circle class="region" cx="100" cy="58" r="36"/>
    <circle class="region" cx="100" cy="98" r="30"/>
  ` + SVG_CLOSE },
};
