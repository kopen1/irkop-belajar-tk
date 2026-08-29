import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

enum LearningType {
  huruf,
  angka,
  hijaiyah,
  gambar,
  warna,
}

class LearningPage extends StatefulWidget {
  final LearningType type;

  const LearningPage({
    super.key,
    required this.type,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage>
    with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  final random = Random();

  late TabController tabs;

  int index = 0;
  int score = 0;

  late LearningItem correct;
  late List<LearningItem> options;

  List<LearningItem> get items {
    switch (widget.type) {
      case LearningType.huruf:
        const examples = [
          '🍎 Apel',
          '⚽ Bola',
          '🐊 Cicak',
          '🦆 Bebek',
          '🐘 Gajah',
          '🌸 Bunga',
          '🐱 Kucing',
          '🐟 Ikan',
          '🌞 Matahari',
          '🚗 Mobil',
          '🍌 Pisang',
          '🏠 Rumah',
          '⭐ Bintang',
          '🌈 Pelangi',
          '🦁 Singa',
          '🐼 Panda',
          '🐰 Kelinci',
          '🐮 Sapi',
          '🐢 Kura-kura',
          '🌷 Bunga',
          '🍇 Anggur',
          '🐯 Harimau',
          '🍉 Semangka',
          '🎁 Hadiah',
          '🚀 Roket',
          '🦓 Zebra',
        ];

        return List.generate(
          26,
          (i) {
            final letter = String.fromCharCode(65 + i);

            return LearningItem(
              title: letter,
              visual: examples[i],
              sound: 'Huruf $letter',
            );
          },
        );

      case LearningType.angka:
        return List.generate(
          10,
          (i) {
            final number = i + 1;

            return LearningItem(
              title: '$number',
              visual: List.filled(number, '⭐').join(' '),
              sound: 'Angka $number',
            );
          },
        );

      case LearningType.hijaiyah:
        const letters = [
          'ا',
          'ب',
          'ت',
          'ث',
          'ج',
          'ح',
          'خ',
          'د',
          'ذ',
          'ر',
          'ز',
          'س',
          'ش',
          'ص',
          'ض',
          'ط',
          'ظ',
          'ع',
          'غ',
          'ف',
          'ق',
          'ك',
          'ل',
          'م',
          'ن',
          'و',
          'ه',
          'لا',
          'ي',
        ];

        return letters
            .map(
              (letter) => LearningItem(
                title: letter,
                visual: letter,
                sound: 'Huruf Hijaiyah $letter',
              ),
            )
            .toList();

      case LearningType.gambar:
        const data = [
          ['🐱', 'Kucing'],
          ['🐶', 'Anjing'],
          ['🐘', 'Gajah'],
          ['🦁', 'Singa'],
          ['🐟', 'Ikan'],
          ['🍎', 'Apel'],
          ['🍌', 'Pisang'],
          ['🍊', 'Jeruk'],
          ['🍇', 'Anggur'],
          ['🍉', 'Semangka'],
          ['🚗', 'Mobil'],
          ['🚌', 'Bus'],
          ['🚆', 'Kereta'],
          ['✈️', 'Pesawat'],
          ['🏠', 'Rumah'],
          ['📚', 'Buku'],
          ['⏰', 'Jam'],
          ['⚽', 'Bola'],
        ];

        return data
            .map(
              (item) => LearningItem(
                title: item[1],
                visual: item[0],
                sound: item[1],
              ),
            )
            .toList();

      case LearningType.warna:
        const data = [
          ['🔴', 'Merah'],
          ['🔵', 'Biru'],
          ['🟡', 'Kuning'],
          ['🟢', 'Hijau'],
          ['🟣', 'Ungu'],
          ['🟠', 'Oranye'],
          ['🩷', 'Merah Muda'],
          ['🟤', 'Cokelat'],
          ['⚪', 'Putih'],
          ['⚫', 'Hitam'],
        ];

        return data
            .map(
              (item) => LearningItem(
                title: item[1],
                visual: item[0],
                sound: item[1],
              ),
            )
            .toList();
    }
  }

  String get title {
    switch (widget.type) {
      case LearningType.huruf:
        return 'Dunia Huruf 🔤';
      case LearningType.angka:
        return 'Dunia Angka 🔢';
      case LearningType.hijaiyah:
        return 'Dunia Hijaiyah 🕌';
      case LearningType.gambar:
        return 'Dunia Gambar 🐱';
      case LearningType.warna:
        return 'Dunia Warna 🎨';
    }
  }

  Color _colorForTitle(String name) {
    const colors = {
      'Merah': Color(0xFFFF6B6B),
      'Biru': Color(0xFF6CA8FF),
      'Kuning': Color(0xFFFFD94D),
      'Hijau': Color(0xFF7DD87D),
      'Ungu': Color(0xFFB08CFF),
      'Oranye': Color(0xFFFFA64D),
      'Merah Muda': Color(0xFFFF9EC9),
      'Cokelat': Color(0xFFB9825A),
      'Putih': Color(0xFFFFFFFF),
      'Hitam': Color(0xFF424242),
    };

    return colors[name] ?? Colors.transparent;
  }

  Color get selectedColor => _colorForTitle(items[index].title);

  @override
  void initState() {
    super.initState();

    tabs = TabController(
      length: 2,
      vsync: this,
    );

    _newQuestion();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => audio.speak(items[index].sound),
    );
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  void _newQuestion() {
    correct = items[random.nextInt(items.length)];

    final wrong = [...items]
      ..removeWhere(
        (item) => item.title == correct.title,
      )
      ..shuffle(random);

    options = [
      correct,
      ...wrong.take(3),
    ]..shuffle(random);
  }

  void next() {
    setState(() {
      index = (index + 1) % items.length;
    });

    audio.speak(items[index].sound);
  }

  void previous() {
    setState(() {
      index = (index - 1 + items.length) % items.length;
    });

    audio.speak(items[index].sound);
  }

  @override
  Widget build(BuildContext context) {
    final item = items[index];

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
              child: KidHeader(
                title: title,
                subtitle: 'Belajar dan bermain bersama',
              ),
            ),
            SizedBox(
              height: 52,
              child: TabBar(
                controller: tabs,
                labelColor: const Color(0xFF31536D),
                unselectedLabelColor: const Color(0xFF55758C),
                indicatorColor: const Color(0xFF31536D),
                indicatorWeight: 4,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: '📚 Belajar'),
                  Tab(text: '🎮 Mini Game'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabs,
                children: [
                  _learn(item),
                  _game(),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _learn(LearningItem item) {
    // Dunia Gambar menggunakan layout visual grid:
    // 1 baris berisi 2 item.
    if (widget.type == LearningType.gambar) {
      return _visualGrid();
    }

    final background = widget.type == LearningType.warna
        ? selectedColor.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.93);

    final visualSize = widget.type == LearningType.hijaiyah ? 96.0 : 70.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Text(
                  item.visual,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: visualSize),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31536D),
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => audio.speak(item.sound),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Dengarkan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: previous,
                  child: const Text('⬅ Sebelumnya'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: next,
                  child: const Text('Selanjutnya ➡'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(
              items.length,
              (i) => GestureDetector(
                onTap: () {
                  setState(() {
                    index = i;
                  });

                  audio.speak(items[i].sound);
                },
                child: Container(
                  width: widget.type == LearningType.warna ? 118 : 50,
                  height: widget.type == LearningType.warna ? 58 : 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.type == LearningType.warna
                        ? _colorForTitle(items[i].title)
                        : i == index
                            ? const Color(0xFFFFD65C)
                            : Colors.white,
                    border: Border.all(
                      color: i == index ? const Color(0xFF31536D) : Colors.white,
                      width: i == index ? 4 : 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x220D405C),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    items[i].title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: widget.type == LearningType.warna ? 13 : 18,
                      color: widget.type == LearningType.warna &&
                              items[i].title == 'Hitam'
                          ? Colors.white
                          : const Color(0xFF31536D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _visualGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, i) {
        final visualItem = items[i];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              setState(() {
                index = i;
              });

              audio.speak(visualItem.sound);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: i == index
                    ? const Color(0xFFFFD65C)
                    : Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            visualItem.visual,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 68,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      visualItem.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF31536D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.volume_up_rounded,
                      size: 22,
                      color: Color(0xFF55758C),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _game() {
    return StatefulBuilder(
      builder: (context, setGameState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          child: Column(
            children: [
              const Text(
                '🧠 Pilih Jawaban yang Benar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF31536D),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                correct.visual,
                style: TextStyle(
                  fontSize: widget.type == LearningType.hijaiyah
                      ? 96
                      : 72,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  audio.question(
                    'Mana ${correct.title}?',
                  );
                },
                child: const Text(
                  '🔊 Dengarkan Pertanyaan',
                ),
              ),
              const SizedBox(height: 12),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (option.title == correct.title) {
                          setGameState(() {
                            score++;
                            _newQuestion();
                          });

                          await audio.correct();
                        } else {
                          await audio.wrong();
                        }
                      },
                      child: Text(option.title),
                    ),
                  ),
                ),
              ),
              Text(
                '⭐ Skor: $score',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
