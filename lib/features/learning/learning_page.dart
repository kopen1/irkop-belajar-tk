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
          ['ا', 'Alif'],
          ['ب', 'Ba'],
          ['ت', 'Ta'],
          ['ث', 'Tsa'],
          ['ج', 'Jim'],
          ['ح', 'Ha'],
          ['خ', 'Kha'],
          ['د', 'Dal'],
          ['ذ', 'Dzal'],
          ['ر', 'Ra'],
          ['ز', 'Zai'],
          ['س', 'Sin'],
          ['ش', 'Syin'],
          ['ص', 'Shad'],
          ['ض', 'Dhad'],
          ['ط', 'Tha'],
          ['ظ', 'Zha'],
          ['ع', 'Ain'],
          ['غ', 'Ghain'],
          ['ف', 'Fa'],
          ['ق', 'Qaf'],
          ['ك', 'Kaf'],
          ['ل', 'Lam'],
          ['م', 'Mim'],
          ['ن', 'Nun'],
          ['و', 'Wau'],
          ['ه', 'Ha'],
          ['لا', 'Lam Alif'],
          ['ي', 'Ya'],
        ];

        return letters
            .map(
              (item) => LearningItem(
                title: item[0],
                visual: item[0],
                sound: item[1],
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
                if (widget.type == LearningType.gambar)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6FF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF9FD3F5),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF31536D),
                      ),
                    ),
                  )
                else
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
                child: _navigationButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Sebelumnya',
                  onPressed: previous,
                  colors: const [Color(0xFF6CA8FF), Color(0xFF4E8DE6)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _navigationButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Selanjutnya',
                  onPressed: next,
                  colors: const [Color(0xFFFFB84D), Color(0xFFFF8F4D)],
                  trailing: true,
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

  Widget _navigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required List<Color> colors,
    bool trailing = false,
  }) {
    final iconWidget = Icon(icon, size: 24, color: Colors.white);
    final labelWidget = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
      ),
    );
    final children = trailing
        ? [labelWidget, const SizedBox(width: 8), iconWidget]
        : [iconWidget, const SizedBox(width: 8), labelWidget];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x330D405C), blurRadius: 8, offset: Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
          ),
        ),
      ),
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
