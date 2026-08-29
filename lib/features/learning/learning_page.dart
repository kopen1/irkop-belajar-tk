import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
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
  late final TabController _tabs;
  late final ConfettiController _confetti;

  final Random _random = Random();

  int _index = 0;
  int _score = 0;

  LearningItem? _question;
  List<LearningItem> _answers = [];

  @override
  void initState() {
    super.initState();

    _tabs = TabController(
      length: 2,
      vsync: this,
    );

    _confetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    AudioService.instance.init();

    _newQuestion();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _confetti.dispose();
    super.dispose();
  }

  Color _colorOf(LearningItem item) {
    final value = item.colorHex;

    if (value == null || value.isEmpty) {
      return Colors.white;
    }

    final hex = value.replaceAll('#', '');

    return Color(
      int.parse('FF$hex', radix: 16),
    );
  }

  Future<void> _speakCurrent() async {
    final item = widget.items[_index];

    await AudioService.instance.speak(
      item.speakText,
    );
  }

  void _next() {
    setState(() {
      _index = (_index + 1) % widget.items.length;
    });

    _speakCurrent();
  }

  void _previous() {
    setState(() {
      _index =
          (_index - 1 + widget.items.length) %
              widget.items.length;
    });

    _speakCurrent();
  }

  void _selectItem(int value) {
    setState(() {
      _index = value;
    });

    _speakCurrent();
  }

  void _newQuestion() {
    final question =
        widget.items[_random.nextInt(widget.items.length)];

    final wrong = [...widget.items]
      ..removeWhere(
        (item) => item.title == question.title,
      )
      ..shuffle(_random);

    setState(() {
      _question = question;

      _answers = [
        question,
        ...wrong.take(3),
      ]..shuffle(_random);
    });
  }

  Future<void> _answer(
    LearningItem answer,
  ) async {
    if (_question == null) return;

    final correct =
        answer.title == _question!.title;

    if (correct) {
      setState(() {
        _score++;
      });

      _confetti.play();

      await AudioService.instance.correct();

      if (!mounted) return;

      Future.delayed(
        const Duration(milliseconds: 900),
        () {
          if (mounted) {
            _newQuestion();
          }
        },
      );
    } else {
      await AudioService.instance.wrong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    12,
                    14,
                    8,
                  ),
                  child: KidHeader(
                    title: widget.title,
                    subtitle: widget.subtitle,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.88,
                    ),
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: TabBar(
                    controller: _tabs,
                    indicator: BoxDecoration(
                      color:
                          const Color(0xFFFFC94D),
                      borderRadius:
                          BorderRadius.circular(17),
                    ),
                    labelColor:
                        const Color(0xFF243B53),
                    unselectedLabelColor:
                        const Color(0xFF607D8B),
                    labelStyle: const TextStyle(
                      fontWeight:
                          FontWeight.w900,
                    ),
                    tabs: const [
                      Tab(
                        text: '📚 Belajar',
                      ),
                      Tab(
                        text: '🎮 Mini Game',
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _buildLearn(),
                      _buildGame(),
                    ],
                  ),
                ),
              ],
            ),

            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality:
                  BlastDirectionality.explosive,
              numberOfParticles: 28,
              gravity: 0.25,
              emissionFrequency: 0.04,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearn() {
    final item = widget.items[_index];

    final itemColor =
        widget.colorMode
            ? _colorOf(item)
            : Colors.white;

    final textColor =
        widget.colorMode &&
                itemColor.computeLuminance() < 0.55
            ? Colors.white
            : const Color(0xFF243B53);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedContainer(
            duration:
                const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius:
                  BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.visual,
                    textAlign:
                        TextAlign.center,
                    style: const TextStyle(
                      fontSize: 82,
                    ),
                  ),
                ),

                Container(
                  width: 2,
                  height: 130,
                  color: Colors.white.withValues(
                    alpha: 0.7,
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              widget.colorMode
                                  ? 32
                                  : 76,
                          fontWeight:
                              FontWeight.w900,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        item.subtitle,
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      FilledButton(
                        onPressed:
                            _speakCurrent,
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF31B94D,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .volume_up_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _previous,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                  label: const Text(
                    'Sebelumnya',
                  ),
                  style:
                      FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFB52E),
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  '${_index + 1} / ${widget.items.length}',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),

              Expanded(
                child: FilledButton.icon(
                  onPressed: _next,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                  ),
                  label: const Text(
                    'Selanjutnya',
                  ),
                  style:
                      FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFB52E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment:
                WrapAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) {
                final selected =
                    index == _index;

                return InkWell(
                  onTap: () =>
                      _selectItem(index),
                  borderRadius:
                      BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    width: 52,
                    height: 52,
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      color: selected
                          ? const Color(
                              0xFFFFC94D,
                            )
                          : Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(14),
                      border: Border.all(
                        color: selected
                            ? const Color(
                                0xFFF5A623,
                              )
                            : const Color(
                                0x22000000,
                              ),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      widget.items[index]
                          .title,
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w900,
                        fontSize: 18,
                        color:
                            Color(0xFF243B53),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    final question = _question;

    if (question == null) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text(
            '🧠 Pilih Jawaban yang Benar!',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF243B53),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.92,
              ),
              borderRadius:
                  BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                Text(
                  question.visual,
                  style: const TextStyle(
                    fontSize: 88,
                  ),
                ),

                const SizedBox(height: 8),

                FilledButton.icon(
                  onPressed: () {
                    AudioService.instance
                        .question(
                      'Mana ${question.title}?',
                    );
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                  ),
                  label: const Text(
                    'Dengarkan Pertanyaan',
                  ),
                  style:
                      FilledButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF31B94D,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: _answers.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
            ),
            itemBuilder:
                (context, index) {
              final item =
                  _answers[index];

              final colors = [
                const Color(0xFFFF6B6B),
                const Color(0xFFFFA940),
                const Color(0xFF53B85D),
                const Color(0xFF5A9CF6),
              ];

              return FilledButton(
                onPressed: () =>
                    _answer(item),
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      colors[index],
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(20),
                  ),
                ),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              '⭐ Skor: $_score',
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
