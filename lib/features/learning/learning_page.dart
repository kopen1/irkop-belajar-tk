import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class LearningPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<LearningItem> items;

  const LearningPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage>
    with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  final random = Random();

  late final TabController tabs;

  int index = 0;
  int score = 0;

  late LearningItem gameCorrect;
  late List<LearningItem> gameOptions;

  bool get isColorMode {
    const colorNames = {
      'Merah',
      'Biru',
      'Kuning',
      'Hijau',
      'Ungu',
      'Oranye',
      'Merah Muda',
      'Cokelat',
      'Putih',
      'Hitam',
    };

    return widget.items.isNotEmpty &&
        colorNames.contains(widget.items.first.title);
  }

  Color get selectedColor {
    final title = widget.items[index].title;

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

    return colors[title] ?? Colors.transparent;
  }

  @override
  void initState() {
    super.initState();

    tabs = TabController(
      length: 2,
      vsync: this,
    );

    _newQuestion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.items.isNotEmpty) {
        audio.speak(widget.items[index].sound);
      }
    });
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  void _newQuestion() {
    if (widget.items.isEmpty) return;

    gameCorrect = widget.items[
      random.nextInt(widget.items.length)
    ];

    final wrong = [...widget.items]
      ..removeWhere(
        (item) => item.title == gameCorrect.title,
      )
      ..shuffle(random);

    gameOptions = [
      gameCorrect,
      ...wrong.take(3),
    ]..shuffle(random);
  }

  void next() {
    if (widget.items.isEmpty) return;

    setState(() {
      index = (index + 1) % widget.items.length;
    });

    audio.speak(widget.items[index].sound);
  }

  void previous() {
    if (widget.items.isEmpty) return;

    setState(() {
      index =
          (index - 1 + widget.items.length) %
          widget.items.length;
    });

    audio.speak(widget.items[index].sound);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Belum ada materi'),
        ),
      );
    }

    final item = widget.items[index];

    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: KidHeader(
                title: widget.title,
                subtitle: widget.subtitle,
              ),
            ),

            TabBar(
              controller: tabs,
              labelColor: const Color(0xFF31536D),
              indicatorColor: const Color(0xFFFFB703),
              tabs: const [
                Tab(text: '📚 Belajar'),
                Tab(text: '🎮 Mini Game'),
              ],
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
    final background = isColorMode
        ? selectedColor.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.93);

    final titleColor =
        item.title == 'Hitam'
            ? Colors.white
            : const Color(0xFF31536D);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  item.visual,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isColorMode ? 110 : 90,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 14),

                FilledButton.icon(
                  onPressed: () {
                    audio.speak(item.sound);
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                  ),
                  label: const Text(
                    'Dengarkan',
                  ),
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
                  child: const Text(
                    '⬅ Sebelumnya',
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton(
                  onPressed: next,
                  child: const Text(
                    'Selanjutnya ➡',
                  ),
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
              widget.items.length,
              (i) => GestureDetector(
                onTap: () {
                  setState(() {
                    index = i;
                  });

                  audio.speak(
                    widget.items[i].sound,
                  );
                },
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 150),
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index
                        ? const Color(0xFFFFD65C)
                        : Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: i == index
                          ? const Color(0xFFFFB703)
                          : const Color(0xFFD6E4EE),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    widget.items[i].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      fontSize: 17,
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

              AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 180),
                child: Text(
                  gameCorrect.visual,
                  key: ValueKey(
                    gameCorrect.title,
                  ),
                  style: const TextStyle(
                    fontSize: 100,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: () {
                  audio.question(
                    'Mana ${gameCorrect.title}?',
                  );
                },
                icon: const Icon(
                  Icons.volume_up_rounded,
                ),
                label: const Text(
                  'Dengarkan Pertanyaan',
                ),
              ),

              const SizedBox(height: 18),

              ...gameOptions.map(
                (option) => Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (option.title ==
                            gameCorrect.title) {
                          await audio.correct();

                          if (!mounted) return;

                          setGameState(() {
                            score++;
                            _newQuestion();
                          });
                        } else {
                          await audio.wrong();
                        }
                      },
                      child: Text(
                        option.title,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '⭐ Skor: $score',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF31536D),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
