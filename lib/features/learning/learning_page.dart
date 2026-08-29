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

  Color get selectedColor {
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

    return colors[items[index].title] ?? Colors.transparent;
  }

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: KidHeader(
                title: title,
                subtitle: 'Belajar dan bermain bersama',
              ),
            ),
            SizedBox(
              height: 58,
              child: TabBar(
                controller: tabs,
                labelColor: const Color(0xFF31536D),
                unselectedLabelColor: const Color(0xFF55758C),
                indicatorColor: const Color(0xFF31536D),
                indicatorWeight: 4,
                labelStyle: const TextStyle(
                  fontSize: 17,
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
    );
  }

  Widget _learn(LearningItem item) {
    final background = widget.type == LearningType.warna
        ? selectedColor.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.93);

    final visualSize = widget.type == LearningType.hijaiyah ? 120.0 : 80.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(36),
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
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31536D),
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => audio.speak(item.sound),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Dengarkan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
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
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index
                        ? const Color(0xFFFFD65C)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    items[i].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
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

  Widget _game() {
    return StatefulBuilder(
      builder: (context, setGameState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const Text(
                '🧠 Pilih Jawaban yang Benar!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF31536D),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                correct.visual,
                style: TextStyle(
                  fontSize: widget.type == LearningType.hijaiyah
                      ? 120
                      : 90,
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 18),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
                  fontSize: 22,
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
