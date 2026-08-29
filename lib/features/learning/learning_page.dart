import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/answer_button.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class LearningPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<LearningItem> items;
  final bool colorMode;

  const LearningPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.colorMode = false,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late ConfettiController _confetti;
  int _index = 0;
  LearningItem? _question;
  List<LearningItem> _answers = [];
  Color _background = const Color(0xFFEAF8FF);
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _newQuestion();
    AudioService.instance.init();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _newQuestion() {
    final random = Random();
    _question = widget.items[random.nextInt(widget.items.length)];

    final pool = [...widget.items]..remove(_question);
    pool.shuffle(random);

    _answers = [
      _question!,
      ...pool.take(3),
    ]..shuffle(random);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.question(
        'Mana ${_question!.title}?',
      );
    });

    setState(() {
      _feedback = '';
    });
  }

  void _answer(LearningItem item) {
    final correct = item.title == _question!.title;

    if (correct) {
      AudioService.instance.correct();
      _confetti.play();

      setState(() {
        _feedback = '🎉 HEBAT! BENAR! ⭐';
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _newQuestion();
      });
    } else {
      AudioService.instance.wrong();

      setState(() {
        _feedback = '😊 Coba lagi ya!';
      });
    }
  }

  Color _hex(String value) {
    final hex = value.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[_index];

    return Scaffold(
      body: KidBackground(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: KidHeader(
                    title: widget.title,
                    subtitle: widget.subtitle,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.88),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TabBar(
                    controller: _tabs,
                    indicator: BoxDecoration(
                      color: const Color(0xFFFFC94D),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelColor: const Color(0xFF354B5E),
                    unselectedLabelColor: const Color(0xFF78909C),
                    tabs: const [
                      Tab(text: '📚 Belajar'),
                      Tab(text: '🎮 Mini Game'),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _buildLearn(item),
                      _buildGame(),
                    ],
                  ),
                ),
              ],
            ),

            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.25,
              emissionFrequency: 0.03,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearn(LearningItem item) {
    final bg = widget.colorMode ? _hex(item.colorHex) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: widget.colorMode ? bg.withOpacity(.25) : Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 290,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: widget.colorMode ? bg : Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: widget.colorMode ? 34 : 92,
                        fontWeight: FontWeight.w900,
                        color: widget.colorMode
                            ? Colors.white
                            : const Color(0xFF354B5E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.visual,
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: widget.colorMode
                            ? Colors.white
                            : const Color(0xFF546E7A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: () {
                  AudioService.instance.speak(
                    '${item.title}. ${item.subtitle}',
                  );
                },
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text(
                  'Dengarkan',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9F43),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 17,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: _index > 0
                        ? () => setState(() => _index--)
                        : null,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 22),
                  Text(
                    '${_index + 1} / ${widget.items.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(width: 22),
                  IconButton.filled(
                    onPressed: _index < widget.items.length - 1
                        ? () => setState(() => _index++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGame() {
    if (_question == null) return const SizedBox();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '🎮 MINI GAME',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: Color(0xFF354B5E),
              ),
            ),
            const SizedBox(height: 8),

            IconButton.filled(
              onPressed: () {
                AudioService.instance.question(
                  'Mana ${_question!.title}?',
                );
              },
              icon: const Icon(Icons.volume_up_rounded),
            ),

            const SizedBox(height: 12),

            Text(
              'Mana ${_question!.title}?',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _question!.visual,
              style: const TextStyle(fontSize: 90),
            ),

            const SizedBox(height: 16),

            if (_feedback.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  _feedback,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _answers.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, index) {
                final answer = _answers[index];

                return AnswerButton(
                  text: answer.title,
                  color: const [
                    Color(0xFF5BA9F7),
                    Color(0xFFFF9F43),
                    Color(0xFF7ACB72),
                    Color(0xFFB082F5),
                  ][index],
                  onTap: () => _answer(answer),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
