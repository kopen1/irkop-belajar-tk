import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IrkopApp());
}

// =================================================
// AUDIO / TTS
// =================================================

class KidAudio {
  KidAudio._();

  static final FlutterTts _tts = FlutterTts();

  static bool backsoundOn = true;

  static Future<void> speak(
    String text, {
    double rate = 0.42,
    double pitch = 1.12,
  }) async {
    try {
      await _tts.stop();
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);
      await _tts.setVolume(1.0);
      await _tts.speak(text);
    } catch (_) {}
  }

  static Future<void> correct() async {
    await speak(
      'Hebat sekali! Jawaban kamu benar!',
      rate: 0.46,
      pitch: 1.25,
    );
  }

  static Future<void> wrong() async {
    await speak(
      'Belum tepat. Yuk coba lagi!',
      rate: 0.42,
      pitch: 1.05,
    );
  }

  static Future<void> completed() async {
    await speak(
      'Hebat! Kamu berhasil menyelesaikan gambar!',
      rate: 0.46,
      pitch: 1.28,
    );
  }

  static Future<void> menuSound(String text) async {
    await speak(text, rate: 0.43, pitch: 1.15);
  }

  static void toggleBacksound() {
    backsoundOn = !backsoundOn;
  }
}

// =================================================
// COLORS
// =================================================

class KidColors {
  static const skyTop = Color(0xFF47B7F3);
  static const skyBottom = Color(0xFFB8E9FF);

  static const navy = Color(0xFF173F78);
  static const yellow = Color(0xFFFFC72E);
  static const orange = Color(0xFFFF8B1F);
  static const red = Color(0xFFFF3D35);
  static const green = Color(0xFF2EBB50);
  static const blue = Color(0xFF2878D8);
  static const purple = Color(0xFF8052D6);
  static const pink = Color(0xFFE94B9B);
}

// =================================================
// APP
// =================================================

class IrkopApp extends StatefulWidget {
  const IrkopApp({super.key});

  @override
  State<IrkopApp> createState() => _IrkoAppState();
}

class _IrkoAppState extends State<IrkopApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRKOP BELAJAR TK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: KidColors.blue,
        ),
      ),
      home: HomePage(
        onMusicChanged: () {
          setState(() {});
        },
      ),
    );
  }
}

// =================================================
// BACKGROUND VISUAL
// =================================================

class KidBackground extends StatelessWidget {
  final Widget child;

  const KidBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            KidColors.skyTop,
            KidColors.skyBottom,
            Color(0xFF9BE7A0),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 30,
            left: 20,
            child: Text(
              '☁️',
              style: TextStyle(fontSize: 58),
            ),
          ),
          const Positioned(
            top: 95,
            right: 20,
            child: Text(
              '☁️',
              style: TextStyle(fontSize: 48),
            ),
          ),
          const Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: Text(
              '🌼   🌷        🌸      🌻',
              style: TextStyle(fontSize: 28),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

// =================================================
// BUTTONS
// =================================================

class KidBackButton extends StatelessWidget {
  const KidBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: KidColors.yellow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: KidColors.navy,
        ),
      ),
    );
  }
}

class AudioButton extends StatelessWidget {
  final VoidCallback onTap;

  const AudioButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 54,
        height: 48,
        decoration: BoxDecoration(
          color: KidColors.green,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.volume_up_rounded,
          color: Colors.white,
          size: 29,
        ),
      ),
    );
  }
}

class KidPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const KidPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =================================================
// PAGE SHELL
// =================================================

class KidPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? right;

  const KidPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                8,
              ),
              child: Row(
                children: [
                  const KidBackButton(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: KidColors.yellow,
                            shadows: [
                              Shadow(
                                color: KidColors.navy,
                                offset: Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  right ?? const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// =================================================
// HOME
// =================================================

class HomePage extends StatelessWidget {
  final VoidCallback onMusicChanged;

  const HomePage({
    super.key,
    required this.onMusicChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuData(
        'ABC',
        'Huruf',
        KidColors.red,
        const HurufPage(),
      ),
      _MenuData(
        '123',
        'Angka',
        KidColors.blue,
        const AngkaPage(),
      ),
      _MenuData(
        'ا ب ت',
        'Hijaiyah',
        KidColors.green,
        const HijaiyahPage(),
      ),
      _MenuData(
        '🦁',
        'Gambar',
        KidColors.orange,
        const GambarPage(),
      ),
      _MenuData(
        '🎨',
        'Warna',
        KidColors.purple,
        const WarnaPage(),
      ),
      _MenuData(
        '🖍️',
        'Mewarnai',
        KidColors.pink,
        const MewarnaiPage(),
      ),
      _MenuData(
        '✏️',
        'Titik & Garis',
        KidColors.yellow,
        const TitikGarisPage(),
      ),
      _MenuData(
        '🏆',
        'Kuis Seru',
        KidColors.purple,
        const KuisPage(),
      ),
    ];

    return Scaffold(
      body: KidBackground(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      KidAudio.toggleBacksound();
                      onMusicChanged();
                      KidAudio.speak(
                        KidAudio.backsoundOn
                            ? 'Musik dinyalakan'
                            : 'Musik dimatikan',
                      );
                    },
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: KidColors.green,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        KidAudio.backsoundOn
                            ? Icons.music_note_rounded
                            : Icons.music_off_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              const Text(
                'IRKOP BELAJAR TK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: KidColors.navy,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Ayo Bermain & Belajar Bersama!',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: KidColors.navy,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: KidPanel(
                  child: GridView.builder(
                    itemCount: menus.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = menus[index];

                      return _HomeMenuCard(
                        data: item,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                '🐼 Yuk pilih permainan favoritmu! 🐼',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: KidColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuData {
  final String icon;
  final String title;
  final Color color;
  final Widget page;

  _MenuData(
    this.icon,
    this.title,
    this.color,
    this.page,
  );
}

class _HomeMenuCard extends StatefulWidget {
  final _MenuData data;

  const _HomeMenuCard({
    required this.data,
  });

  @override
  State<_HomeMenuCard> createState() =>
      _HomeMenuCardState();
}

class _HomeMenuCardState extends State<_HomeMenuCard> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => scale = .94);
      },
      onTapCancel: () {
        setState(() => scale = 1);
      },
      onTapUp: (_) {
        setState(() => scale = 1);

        KidAudio.menuSound(
          'Membuka ${widget.data.title}',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => widget.data.page,
          ),
        );
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.data.color,
                widget.data.color.withOpacity(.72),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 7,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.data.icon,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: KidColors.navy,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================
// LEARNING WITH TAB
// =================================================

class LearnTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const LearnTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            title: '📚 Belajar',
            active: selected == 0,
            onTap: () => onChanged(0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabButton(
            title: '🎮 Mini Game',
            active: selected == 1,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: active
              ? KidColors.yellow
              : Colors.white.withOpacity(.82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? KidColors.orange
                : Colors.white,
            width: 3,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: active
                ? KidColors.navy
                : KidColors.navy,
          ),
        ),
      ),
    );
  }
}

// =================================================
// GENERIC MINI QUIZ
// =================================================

class MiniQuizCard extends StatefulWidget {
  final String question;
  final List<String> answers;
  final int correct;
  final VoidCallback onNext;

  const MiniQuizCard({
    super.key,
    required this.question,
    required this.answers,
    required this.correct,
    required this.onNext,
  });

  @override
  State<MiniQuizCard> createState() =>
      _MiniQuizCardState();
}

class _MiniQuizCardState extends State<MiniQuizCard> {
  int? selected;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        KidAudio.speak(widget.question);
      },
    );
  }

  void answer(int index) {
    if (selected != null) return;

    setState(() {
      selected = index;
    });

    if (index == widget.correct) {
      KidAudio.correct();

      Future.delayed(
        const Duration(milliseconds: 900),
        () {
          if (mounted) widget.onNext();
        },
      );
    } else {
      KidAudio.wrong();

      Future.delayed(
        const Duration(milliseconds: 700),
        () {
          if (mounted) {
            setState(() {
              selected = null;
            });
          }
        },
      );
    }
  }

  Color buttonColor(int index) {
    if (selected == null) {
      return Colors.white;
    }

    if (index == selected) {
      return index == widget.correct
          ? KidColors.green
          : KidColors.red;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return KidPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AudioButton(
            onTap: () {
              KidAudio.speak(widget.question);
            },
          ),
          const SizedBox(height: 14),
          Text(
            widget.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: KidColors.navy,
            ),
          ),
          const SizedBox(height: 22),
          ...List.generate(
            widget.answers.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: InkWell(
                  onTap: () => answer(index),
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 220,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: buttonColor(index),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: KidColors.blue,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      widget.answers[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: selected == index
                            ? Colors.white
                            : KidColors.navy,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =================================================
// HURUF
// =================================================

class HurufPage extends StatefulWidget {
  const HurufPage({super.key});

  @override
  State<HurufPage> createState() => _HurufPageState();
}

class _HurufPageState extends State<HurufPage> {
  int tab = 0;
  int index = 0;

  final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  final examples = const [
    ('🍎', 'Apel'),
    ('⚽', 'Bola'),
    ('🐱', 'Kucing'),
    ('🦕', 'Dinosaurus'),
    ('🐘', 'Gajah'),
    ('🐟', 'Ikan'),
    ('🦒', 'Jerapah'),
    ('🐔', 'Ayam'),
    ('🍦', 'Es krim'),
    ('🐸', 'Katak'),
    ('🐰', 'Kelinci'),
    ('🦁', 'Singa'),
    ('🐱', 'Meong'),
    ('🌴', 'Nanas'),
    ('🍊', 'Jeruk'),
    ('🦆', 'Bebek'),
    ('🎁', 'Kado'),
    ('🚗', 'Mobil'),
    ('☀️', 'Matahari'),
    ('🍅', 'Tomat'),
    ('☂️', 'Payung'),
    ('🌋', 'Gunung'),
    ('🍉', 'Semangka'),
    ('❌', 'Xilofon'),
    ('🪀', 'Yoyo'),
    ('🦓', 'Zebra'),
  ];

  void next() {
    setState(() {
      index = (index + 1) % letters.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = letters[index];
    final example = examples[index];

    return KidPage(
      title: 'Belajar Huruf',
      subtitle: 'Mengenal Huruf A - Z',
      right: AudioButton(
        onTap: () {
          KidAudio.speak(
            'Huruf $letter. ${example.$2}',
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            LearnTabs(
              selected: tab,
              onChanged: (value) {
                setState(() => tab = value);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tab == 0
                  ? KidPanel(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 145,
                                        fontWeight:
                                            FontWeight.w900,
                                        color: KidColors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        example.$1,
                                        style:
                                            const TextStyle(
                                          fontSize: 95,
                                        ),
                                      ),
                                      Text(
                                        example.$2,
                                        style:
                                            const TextStyle(
                                          fontSize: 25,
                                          fontWeight:
                                              FontWeight.w900,
                                          color:
                                              KidColors.navy,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      AudioButton(
                                        onTap: () {
                                          KidAudio.speak(
                                            'Huruf $letter. ${example.$2}',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _Pager(
                            label:
                                '${index + 1} / ${letters.length}',
                            onPrev: () {
                              setState(() {
                                index =
                                    (index - 1 + letters.length) %
                                        letters.length;
                              });
                            },
                            onNext: next,
                          ),
                        ],
                      ),
                    )
                  : LetterMiniGame(
                      letters: letters,
                      onChanged: next,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class LetterMiniGame extends StatefulWidget {
  final List<String> letters;
  final VoidCallback onChanged;

  const LetterMiniGame({
    super.key,
    required this.letters,
    required this.onChanged,
  });

  @override
  State<LetterMiniGame> createState() =>
      _LetterMiniGameState();
}

class _LetterMiniGameState
    extends State<LetterMiniGame> {
  final Random random = Random();
  late String target;
  late List<String> options;

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    target =
        widget.letters[random.nextInt(widget.letters.length)];

    final set = <String>{target};

    while (set.length < 3) {
      set.add(
        widget.letters[
            random.nextInt(widget.letters.length)],
      );
    }

    options = set.toList()..shuffle();
  }

  void next() {
    setState(generate);
  }

  @override
  Widget build(BuildContext context) {
    return MiniQuizCard(
      key: ValueKey(target),
      question: 'Mana huruf $target?',
      answers: options,
      correct: options.indexOf(target),
      onNext: next,
    );
  }
}

// =================================================
// ANGKA
// =================================================

class AngkaPage extends StatefulWidget {
  const AngkaPage({super.key});

  @override
  State<AngkaPage> createState() => _AngkaPageState();
}

class _AngkaPageState extends State<AngkaPage> {
  int tab = 0;
  int number = 1;

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Belajar Angka',
      subtitle: 'Mengenal Angka 1 - 20',
      right: AudioButton(
        onTap: () => KidAudio.speak('$number'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            LearnTabs(
              selected: tab,
              onChanged: (value) {
                setState(() => tab = value);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tab == 0
                  ? KidPanel(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$number',
                                    style: const TextStyle(
                                      fontSize: 140,
                                      fontWeight:
                                          FontWeight.w900,
                                      color:
                                          KidColors.orange,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    alignment:
                                        WrapAlignment.center,
                                    children: List.generate(
                                      min(number, 20),
                                      (_) => const Text(
                                        '⭐',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AudioButton(
                                    onTap: () =>
                                        KidAudio.speak(
                                      '$number',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _Pager(
                            label: '$number / 20',
                            onPrev: () {
                              setState(() {
                                number =
                                    number == 1 ? 20 : number - 1;
                              });
                            },
                            onNext: () {
                              setState(() {
                                number =
                                    number == 20 ? 1 : number + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : NumberMiniGame(),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberMiniGame extends StatefulWidget {
  const NumberMiniGame({super.key});

  @override
  State<NumberMiniGame> createState() =>
      _NumberMiniGameState();
}

class _NumberMiniGameState
    extends State<NumberMiniGame> {
  final Random random = Random();
  late int target;
  late List<int> options;

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    target = random.nextInt(10) + 1;

    final set = <int>{target};

    while (set.length < 3) {
      set.add(random.nextInt(10) + 1);
    }

    options = set.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return MiniQuizCard(
      key: ValueKey(target),
      question: 'Pilih angka $target',
      answers: options.map((e) => '$e').toList(),
      correct: options.indexOf(target),
      onNext: () => setState(generate),
    );
  }
}

// =================================================
// HIJAIYAH
// =================================================

class HijaiyahPage extends StatefulWidget {
  const HijaiyahPage({super.key});

  @override
  State<HijaiyahPage> createState() =>
      _HijaiyahPageState();
}

class _HijaiyahPageState
    extends State<HijaiyahPage> {
  int tab = 0;
  int index = 0;

  final letters = const [
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
    'ه',
    'و',
    'ي',
    'لا',
    'ء',
  ];

  final names = const [
    'Alif',
    'Ba',
    'Ta',
    'Tsa',
    'Jim',
    'Ha',
    'Kho',
    'Dal',
    'Dzal',
    'Ra',
    'Zai',
    'Sin',
    'Syin',
    'Shad',
    'Dhad',
    'Tha',
    'Zha',
    'Ain',
    'Ghain',
    'Fa',
    'Qaf',
    'Kaf',
    'Lam',
    'Mim',
    'Nun',
    'Ha',
    'Wau',
    'Ya',
    'Lam Alif',
    'Hamzah',
  ];

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Belajar Hijaiyah',
      subtitle: 'Mengenal Huruf Arab',
      right: AudioButton(
        onTap: () {
          KidAudio.speak(names[index]);
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            LearnTabs(
              selected: tab,
              onChanged: (value) {
                setState(() => tab = value);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tab == 0
                  ? KidPanel(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    letters[index],
                                    style: const TextStyle(
                                      fontSize: 140,
                                      fontWeight:
                                          FontWeight.w900,
                                      color:
                                          KidColors.purple,
                                    ),
                                  ),
                                  Text(
                                    names[index],
                                    style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight:
                                          FontWeight.w900,
                                      color:
                                          KidColors.navy,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  AudioButton(
                                    onTap: () =>
                                        KidAudio.speak(
                                      names[index],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _Pager(
                            label:
                                '${index + 1} / ${letters.length}',
                            onPrev: () {
                              setState(() {
                                index =
                                    (index - 1 + letters.length) %
                                        letters.length;
                              });
                            },
                            onNext: () {
                              setState(() {
                                index =
                                    (index + 1) % letters.length;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : HijaiyahMiniGame(
                      letters: letters,
                      names: names,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HijaiyahMiniGame extends StatefulWidget {
  final List<String> letters;
  final List<String> names;

  const HijaiyahMiniGame({
    super.key,
    required this.letters,
    required this.names,
  });

  @override
  State<HijaiyahMiniGame> createState() =>
      _HijaiyahMiniGameState();
}

class _HijaiyahMiniGameState
    extends State<HijaiyahMiniGame> {
  final Random random = Random();
  late int target;
  late List<int> options;

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    target = random.nextInt(widget.letters.length);

    final set = <int>{target};

    while (set.length < 3) {
      set.add(
        random.nextInt(widget.letters.length),
      );
    }

    options = set.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return MiniQuizCard(
      key: ValueKey(target),
      question:
          'Mana huruf ${widget.names[target]}?',
      answers: options
          .map((index) => widget.letters[index])
          .toList(),
      correct: options.indexOf(target),
      onNext: () => setState(generate),
    );
  }
}

// =================================================
// GAMBAR
// =================================================

class GambarPage extends StatefulWidget {
  const GambarPage({super.key});

  @override
  State<GambarPage> createState() =>
      _GambarPageState();
}

class _GambarPageState extends State<GambarPage> {
  int tab = 0;
  String category = 'Hewan';

  final data = const {
    'Hewan': [
      ('🐱', 'Kucing'),
      ('🦁', 'Singa'),
      ('🐘', 'Gajah'),
      ('🐰', 'Kelinci'),
      ('🦒', 'Jerapah'),
      ('🦓', 'Zebra'),
      ('🐔', 'Ayam'),
      ('🦆', 'Bebek'),
      ('🐦', 'Burung'),
    ],
    'Buah': [
      ('🍎', 'Apel'),
      ('🍌', 'Pisang'),
      ('🍊', 'Jeruk'),
      ('🍇', 'Anggur'),
      ('🍉', 'Semangka'),
      ('🍓', 'Stroberi'),
    ],
    'Kendaraan': [
      ('🚗', 'Mobil'),
      ('🚌', 'Bus'),
      ('🚑', 'Ambulans'),
      ('🚒', 'Mobil Pemadam'),
      ('🚲', 'Sepeda'),
      ('🚜', 'Traktor'),
    ],
    'Benda': [
      ('🎒', 'Tas'),
      ('⚽', 'Bola'),
      ('📚', 'Buku'),
      ('✏️', 'Pensil'),
      ('🧸', 'Boneka'),
      ('🏠', 'Rumah'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Belajar Gambar',
      subtitle: 'Mengenal Benda di Sekitar Kita',
      right: AudioButton(
        onTap: () =>
            KidAudio.speak('Belajar gambar'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            LearnTabs(
              selected: tab,
              onChanged: (value) {
                setState(() => tab = value);
              },
            ),
            const SizedBox(height: 10),
            if (tab == 0)
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: data.keys.map((item) {
                    final active = category == item;

                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        selected: active,
                        onSelected: (_) {
                          setState(() {
                            category = item;
                          });
                          KidAudio.speak(item);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: tab == 0
                  ? KidPanel(
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: data[category]!
                            .map(
                              (item) => InkWell(
                                onTap: () {
                                  KidAudio.speak(item.$2);
                                },
                                borderRadius:
                                    BorderRadius.circular(18),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF8F8F8,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    border: Border.all(
                                      color: KidColors.blue
                                          .withOpacity(.2),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.$1,
                                        style:
                                            const TextStyle(
                                          fontSize: 52,
                                        ),
                                      ),
                                      Text(
                                        item.$2,
                                        textAlign:
                                            TextAlign.center,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : GambarMiniGame(data: data),
            ),
          ],
        ),
      ),
    );
  }
}

class GambarMiniGame extends StatefulWidget {
  final Map<String, List<(String, String)>> data;

  const GambarMiniGame({
    super.key,
    required this.data,
  });

  @override
  State<GambarMiniGame> createState() =>
      _GambarMiniGameState();
}

class _GambarMiniGameState
    extends State<GambarMiniGame> {
  final Random random = Random();
  late List<(String, String)> items;
  late int correct;

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    final all =
        widget.data.values.expand((e) => e).toList()
          ..shuffle();

    items = all.take(3).toList();
    correct = random.nextInt(items.length);
  }

  @override
  Widget build(BuildContext context) {
    final target = items[correct];

    return MiniQuizCard(
      key: ValueKey(
        '${target.$1}${target.$2}',
      ),
      question: 'Mana gambar ${target.$2}?',
      answers: items.map((e) => e.$1).toList(),
      correct: correct,
      onNext: () => setState(generate),
    );
  }
}

// =================================================
// WARNA
// =================================================

class WarnaPage extends StatefulWidget {
  const WarnaPage({super.key});

  @override
  State<WarnaPage> createState() =>
      _WarnaPageState();
}

class _WarnaPageState extends State<WarnaPage> {
  int tab = 0;

  final colors = <String, Color>{
    'Merah': const Color(0xFFF22D2D),
    'Oranye': const Color(0xFFFF7D1A),
    'Kuning': const Color(0xFFFFD21F),
    'Hijau': const Color(0xFF22A947),
    'Biru': const Color(0xFF236FD0),
    'Ungu': const Color(0xFF7042C8),
    'Pink': const Color(0xFFE84C9A),
    'Coklat': const Color(0xFF75402B),
    'Hitam': const Color(0xFF22252C),
    'Putih': const Color(0xFFF8F8F8),
    'Abu-abu': const Color(0xFF9AA1AA),
    'Biru Muda': const Color(0xFF5DD5F2),
  };

  String selected = 'Merah';

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Belajar Warna',
      subtitle: 'Mengenal Berbagai Warna',
      right: AudioButton(
        onTap: () => KidAudio.speak(selected),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            LearnTabs(
              selected: tab,
              onChanged: (value) {
                setState(() => tab = value);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tab == 0
                  ? AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 350,
                      ),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors[selected]
                            ?.withOpacity(.28),
                        borderRadius:
                            BorderRadius.circular(26),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: KidPanel(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '💥',
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          const TextStyle(
                                        fontSize: 100,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          selected,
                                          style:
                                              TextStyle(
                                            color:
                                                colors[selected],
                                            fontSize: 34,
                                            fontWeight:
                                                FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        AudioButton(
                                          onTap: () =>
                                              KidAudio.speak(
                                            selected,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            flex: 4,
                            child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 1.8,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              children:
                                  colors.entries.map((entry) {
                                final active =
                                    selected == entry.key;

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selected =
                                          entry.key;
                                    });
                                    KidAudio.speak(
                                      entry.key,
                                    );
                                  },
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(
                                      milliseconds: 200,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: entry.value,
                                      borderRadius:
                                          BorderRadius
                                              .circular(16),
                                      border: Border.all(
                                        color: active
                                            ? Colors.white
                                            : Colors
                                                .transparent,
                                        width: active ? 4 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        entry.key,
                                        textAlign:
                                            TextAlign.center,
                                        style: TextStyle(
                                          color: entry.key ==
                                                      'Putih' ||
                                                  entry.key ==
                                                      'Kuning'
                                              ? KidColors
                                                  .navy
                                              : Colors.white,
                                          fontWeight:
                                              FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : WarnaMiniGame(colors: colors),
            ),
          ],
        ),
      ),
    );
  }
}

class WarnaMiniGame extends StatefulWidget {
  final Map<String, Color> colors;

  const WarnaMiniGame({
    super.key,
    required this.colors,
  });

  @override
  State<WarnaMiniGame> createState() =>
      _WarnaMiniGameState();
}

class _WarnaMiniGameState
    extends State<WarnaMiniGame> {
  final Random random = Random();
  late String target;
  late List<String> options;

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    final keys = widget.colors.keys.toList();
    target = keys[random.nextInt(keys.length)];

    final set = <String>{target};

    while (set.length < 3) {
      set.add(keys[random.nextInt(keys.length)]);
    }

    options = set.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return MiniQuizCard(
      key: ValueKey(target),
      question: 'Mana warna $target?',
      answers: options,
      correct: options.indexOf(target),
      onNext: () => setState(generate),
    );
  }
}

// =================================================
// MEWARNAI
// =================================================

class MewarnaiPage extends StatefulWidget {
  const MewarnaiPage({super.key});

  @override
  State<MewarnaiPage> createState() =>
      _MewarnaiPageState();
}

class _MewarnaiPageState
    extends State<MewarnaiPage> {
  Color selectedColor = Colors.red;
  bool eraser = false;
  int clearSignal = 0;

  final palette = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Ayo Mewarnai',
      subtitle: 'Warnai Gambar Sesuai Contoh!',
      right: AudioButton(
        onTap: () => KidAudio.speak(
          'Pilih warna, lalu warnai gambar sesuai contoh',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: KidPanel(
                      child: Column(
                        children: [
                          const Text(
                            'CONTOH JADI',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                              color: KidColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Center(
                              child: Text(
                                '🦕',
                                style:
                                    const TextStyle(
                                  fontSize: 150,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Dinosaurus Hijau',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: KidPanel(
                      child: Column(
                        children: [
                          const Text(
                            'WARNAI DI SINI',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                              color: KidColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: PaintBoard(
                              color: eraser
                                  ? Colors.white
                                  : selectedColor,
                              eraser: eraser,
                              clearSignal: clearSignal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            KidPanel(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: palette.map((color) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                            eraser = false;
                          });
                          KidAudio.speak('Pilih cat');
                        },
                        borderRadius:
                            BorderRadius.circular(50),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor ==
                                          color &&
                                      !eraser
                                  ? KidColors.navy
                                  : Colors.white,
                              width: 4,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              eraser = false;
                            });
                            KidAudio.speak('Cat');
                          },
                          icon:
                              const Icon(Icons.brush),
                          label: const Text('Cat'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              eraser = true;
                            });
                            KidAudio.speak('Hapus');
                          },
                          icon: const Icon(
                            Icons.cleaning_services,
                          ),
                          label: const Text('Hapus'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                KidColors.red,
                            foregroundColor:
                                Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              clearSignal++;
                            });
                            KidAudio.speak(
                              'Bersihkan gambar',
                            );
                          },
                          icon:
                              const Icon(Icons.delete),
                          label:
                              const Text('Bersihkan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaintBoard extends StatefulWidget {
  final Color color;
  final bool eraser;
  final int clearSignal;

  const PaintBoard({
    super.key,
    required this.color,
    required this.eraser,
    required this.clearSignal,
  });

  @override
  State<PaintBoard> createState() =>
      _PaintBoardState();
}

class _PaintBoardState extends State<PaintBoard> {
  final List<_Stroke> strokes = [];

  @override
  void didUpdateWidget(
    covariant PaintBoard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.clearSignal != oldWidget.clearSignal) {
      strokes.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          strokes.add(
            _Stroke(
              points: [
                details.localPosition,
              ],
              color: widget.color,
              width:
                  widget.eraser ? 24 : 12,
            ),
          );
        });
      },
      onPanUpdate: (details) {
        if (strokes.isEmpty) return;

        setState(() {
          strokes.last.points
              .add(details.localPosition);
        });
      },
      child: CustomPaint(
        painter: _PaintBoardPainter(
          strokes,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: KidColors.navy
                  .withOpacity(.25),
              width: 2,
            ),
          ),
          child: const Center(
            child: Text(
              '🦕',
              style: TextStyle(
                fontSize: 135,
                color: Colors.black12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  _Stroke({
    required this.points,
    required this.color,
    required this.width,
  });
}

class _PaintBoardPainter
    extends CustomPainter {
  final List<_Stroke> strokes;

  _PaintBoardPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (
        var i = 0;
        i < stroke.points.length - 1;
        i++
      ) {
        canvas.drawLine(
          stroke.points[i],
          stroke.points[i + 1],
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _PaintBoardPainter oldDelegate,
  ) {
    return true;
  }
}

// =================================================
// TITIK DAN GARIS
// =================================================

class DotPicture {
  final String name;
  final String emoji;
  final List<Offset> points;

  const DotPicture({
    required this.name,
    required this.emoji,
    required this.points,
  });
}

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() =>
      _TitikGarisPageState();
}

class _TitikGarisPageState
    extends State<TitikGarisPage> {
  final ConfettiController confetti =
      ConfettiController(
    duration: const Duration(seconds: 2),
  );

  int pictureIndex = 0;
  int current = 0;
  bool completed = false;
  Offset? dragging;

  final pictures = const [
    DotPicture(
      name: 'Bintang',
      emoji: '⭐',
      points: [
        Offset(.50, .08),
        Offset(.60, .38),
        Offset(.92, .38),
        Offset(.66, .56),
        Offset(.76, .90),
        Offset(.50, .69),
        Offset(.24, .90),
        Offset(.34, .56),
        Offset(.08, .38),
        Offset(.40, .38),
      ],
    ),
    DotPicture(
      name: 'Rumah',
      emoji: '🏠',
      points: [
        Offset(.18, .55),
        Offset(.50, .18),
        Offset(.82, .55),
        Offset(.82, .88),
        Offset(.18, .88),
        Offset(.18, .55),
      ],
    ),
    DotPicture(
      name: 'Ikan',
      emoji: '🐟',
      points: [
        Offset(.18, .50),
        Offset(.35, .28),
        Offset(.65, .28),
        Offset(.82, .50),
        Offset(.65, .72),
        Offset(.35, .72),
        Offset(.18, .50),
        Offset(.06, .30),
        Offset(.06, .70),
        Offset(.18, .50),
      ],
    ),
    DotPicture(
      name: 'Apel',
      emoji: '🍎',
      points: [
        Offset(.50, .20),
        Offset(.62, .12),
        Offset(.75, .30),
        Offset(.78, .65),
        Offset(.62, .88),
        Offset(.38, .88),
        Offset(.22, .65),
        Offset(.25, .30),
        Offset(.38, .12),
        Offset(.50, .20),
      ],
    ),
  ];

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  void reset() {
    setState(() {
      current = 0;
      completed = false;
      dragging = null;
    });
  }

  void nextPicture() {
    setState(() {
      pictureIndex =
          (pictureIndex + 1) % pictures.length;
      current = 0;
      completed = false;
      dragging = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final picture = pictures[pictureIndex];

    return KidPage(
      title: 'Titik & Garis',
      subtitle: completed
          ? 'Hebat! Ini gambar aslinya!'
          : 'Tarik garis sesuai urutan nomor',
      right: AudioButton(
        onTap: () => KidAudio.speak(
          completed
              ? 'Hebat! Kamu membuat ${picture.name}'
              : 'Tarik garis dari titik ${current + 1} ke titik ${current + 2}',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            Column(
              children: [
                KidPanel(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    completed
                        ? '🎉 ${picture.name} 🎉'
                        : 'Tarik dari titik ${current + 1} ke titik ${current + 2}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                      color: KidColors.navy,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: KidPanel(
                    child: completed
                        ? Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                picture.emoji,
                                style: const TextStyle(
                                  fontSize: 160,
                                ),
                              ),
                              Text(
                                'Ini gambar ${picture.name}!',
                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.w900,
                                  color:
                                      KidColors.navy,
                                ),
                              ),
                            ],
                          )
                        : LayoutBuilder(
                            builder:
                                (context, constraints) {
                              final absolute =
                                  picture.points
                                      .map(
                                        (p) => Offset(
                                          p.dx *
                                              constraints
                                                  .maxWidth,
                                          p.dy *
                                              constraints
                                                  .maxHeight,
                                        ),
                                      )
                                      .toList();

                              return GestureDetector(
                                onPanStart:
                                    (details) {
                                  if (current >=
                                      absolute.length -
                                          1) {
                                    return;
                                  }

                                  final start =
                                      absolute[current];

                                  if ((details
                                              .localPosition -
                                          start)
                                      .distance <
                                      35) {
                                    setState(() {
                                      dragging =
                                          details
                                              .localPosition;
                                    });
                                  }
                                },
                                onPanUpdate:
                                    (details) {
                                  if (dragging !=
                                      null) {
                                    setState(() {
                                      dragging =
                                          details
                                              .localPosition;
                                    });
                                  }
                                },
                                onPanEnd:
                                    (_) {
                                  if (dragging ==
                                      null) {
                                    return;
                                  }

                                  final next =
                                      absolute[
                                          current + 1];

                                  if ((dragging! -
                                              next)
                                          .distance <
                                      42) {
                                    setState(() {
                                      current++;
                                      dragging = null;
                                    });

                                    if (current ==
                                        absolute.length -
                                            1) {
                                      confetti.play();

                                      setState(() {
                                        completed = true;
                                      });

                                      KidAudio
                                          .completed();
                                    }
                                  } else {
                                    setState(() {
                                      dragging = null;
                                    });

                                    KidAudio.speak(
                                      'Coba lagi dari titik ${current + 1}',
                                    );
                                  }
                                },
                                child: CustomPaint(
                                  painter:
                                      DotPainter(
                                    points:
                                        absolute,
                                    current:
                                        current,
                                    dragging:
                                        dragging,
                                  ),
                                  child:
                                      const SizedBox
                                          .expand(),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: reset,
                        child:
                            const Text('🔄 Ulang'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: nextPicture,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              KidColors.yellow,
                          foregroundColor:
                              KidColors.navy,
                        ),
                        child: const Text(
                          'Gambar Berikutnya ➜',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                blastDirectionality:
                    BlastDirectionality.explosive,
                numberOfParticles: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotPainter extends CustomPainter {
  final List<Offset> points;
  final int current;
  final Offset? dragging;

  DotPainter({
    required this.points,
    required this.current,
    required this.dragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final donePaint = Paint()
      ..color = KidColors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final guidePaint = Paint()
      ..color = KidColors.navy
          .withOpacity(.55)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      if (i < current) {
        canvas.drawLine(
          points[i],
          points[i + 1],
          donePaint,
        );
      } else {
        canvas.drawLine(
          points[i],
          points[i + 1],
          guidePaint,
        );
      }
    }

    if (dragging != null &&
        current < points.length - 1) {
      canvas.drawLine(
        points[current],
        dragging!,
        donePaint,
      );
    }

    for (var i = 0; i < points.length; i++) {
      final active =
          i == current ||
              i == current + 1;

      final paint = Paint()
        ..color = active
            ? KidColors.orange
            : KidColors.blue;

      canvas.drawCircle(
        points[i],
        18,
        paint,
      );

      final painter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w900,
            fontSize: 16,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      painter.paint(
        canvas,
        points[i] -
            Offset(
              painter.width / 2,
              painter.height / 2,
            ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant DotPainter oldDelegate,
  ) {
    return true;
  }
}

// =================================================
// MAIN QUIZ
// =================================================

class QuizItem {
  final String question;
  final List<String> options;
  final int correct;

  const QuizItem({
    required this.question,
    required this.options,
    required this.correct,
  });
}

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() =>
      _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  final Random random = Random();

  final bank = const [
    QuizItem(
      question: 'Mana huruf A?',
      options: ['A', 'B', 'D'],
      correct: 0,
    ),
    QuizItem(
      question: 'Angka setelah dua adalah?',
      options: ['1', '3', '5'],
      correct: 1,
    ),
    QuizItem(
      question: 'Mana huruf Alif?',
      options: ['ا', 'ب', 'ت'],
      correct: 0,
    ),
    QuizItem(
      question: 'Mana gambar ikan?',
      options: ['🐱', '🐟', '🚗'],
      correct: 1,
    ),
    QuizItem(
      question: 'Mana warna merah?',
      options: ['Merah', 'Hijau', 'Biru'],
      correct: 0,
    ),
    QuizItem(
      question: 'Hewan manakah yang berbunyi meong?',
      options: ['🐶', '🐱', '🐘'],
      correct: 1,
    ),
    QuizItem(
      question: 'Berapa jumlah jari pada satu tangan?',
      options: ['3', '5', '8'],
      correct: 1,
    ),
  ];

  int score = 0;
  late QuizItem item;

  @override
  void initState() {
    super.initState();
    item = bank[random.nextInt(bank.length)];

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        KidAudio.speak(item.question);
      },
    );
  }

  void next() {
    setState(() {
      item = bank[random.nextInt(bank.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return KidPage(
      title: 'Kuis Seru',
      subtitle: 'Ayo Jawab Pertanyaannya!',
      right: AudioButton(
        onTap: () =>
            KidAudio.speak(item.question),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            KidPanel(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 18,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🏆 Kuis Tanpa Batas',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      color: KidColors.navy,
                    ),
                  ),
                  Text(
                    '⭐ $score',
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      color: KidColors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: MiniQuizCard(
                key: ValueKey(
                  '${item.question}$score',
                ),
                question: item.question,
                answers: item.options,
                correct: item.correct,
                onNext: () {
                  setState(() {
                    score++;
                  });
                  next();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// PAGER
// =================================================

class _Pager extends StatelessWidget {
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _Pager({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PagerButton(
          icon: Icons.arrow_back_rounded,
          onTap: onPrev,
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: KidColors.navy,
            ),
          ),
        ),
        _PagerButton(
          icon: Icons.arrow_forward_rounded,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _PagerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PagerButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 52,
        height: 48,
        decoration: BoxDecoration(
          color: KidColors.yellow,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: KidColors.orange,
            width: 3,
          ),
        ),
        child: Icon(
          icon,
          color: KidColors.navy,
        ),
      ),
    );
  }
}
