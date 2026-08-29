import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class HurufPage extends StatefulWidget {
  const HurufPage({super.key});

  @override
  State<HurufPage> createState() => _HurufPageState();
}

class _HurufPageState extends State<HurufPage>
    with SingleTickerProviderStateMixin {
  final AudioService audio = AudioService.instance;
  late final TabController _tabs;
  int _index = 0;
  int _score = 0;

  static const _letters = [
    'A','B','C','D','E','F','G','H','I',
    'J','K','L','M','N','O','P','Q','R',
    'S','T','U','V','W','X','Y','Z',
  ];
  static const _names = [
    'A','Be','Ce','De','E','Ef','Ge','Ha','I',
    'Je','Ka','El','Em','En','O','Pe','Ki','Er',
    'Es','Te','U','Ve','We','Eks','Ye','Zet',
  ];

  String get letter => _letters[_index];
  String get letterName => _names[_index];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _select(int value) {
    setState(() => _index = value);
    audio.speak('Huruf ${_names[value]}');
  }

  void _previous() {
    setState(() => _index = (_index - 1 + _letters.length) % _letters.length);
    audio.speak('Huruf $letterName');
  }

  void _next() {
    setState(() => _index = (_index + 1) % _letters.length);
    audio.speak('Huruf $letterName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 390;
              return Column(
                children: [
                  _header(compact),
                  _tabBar(compact),
                  Expanded(
                    child: TabBarView(
                      controller: _tabs,
                      children: [_learn(compact), _game(compact)],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(bool compact) {
    final side = compact ? 58.0 : 68.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 10 : 16, 12, compact ? 10 : 16, 8),
      child: Row(
        children: [
          _roundControl(
            size: side,
            icon: Icons.arrow_back_rounded,
            background: Colors.white.withValues(alpha: 0.94),
            foreground: const Color(0xFF31536D),
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: compact ? 100 : 112,
              padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 6)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dunia Huruf 🔤',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF31536D),
                      fontSize: compact ? 25 : 31,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Belajar huruf sambil bermain',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF61798C),
                      fontSize: compact ? 13 : 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          _roundControl(
            size: side,
            icon: Icons.volume_up_rounded,
            background: const Color(0xFF35C84A),
            foreground: Colors.white,
            onTap: () => audio.speak('Dunia Huruf. Belajar huruf sambil bermain.'),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(bool compact) {
    return Container(
      height: compact ? 76 : 84,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TabBar(
        controller: _tabs,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: compact ? 5 : 6, color: const Color(0xFF31536D)),
          insets: const EdgeInsets.symmetric(horizontal: 24),
        ),
        labelColor: const Color(0xFF31536D),
        unselectedLabelColor: const Color(0xFF61798C),
        labelStyle: TextStyle(fontSize: compact ? 20 : 23, fontWeight: FontWeight.w900),
        tabs: const [
          Tab(text: '📚 Belajar'),
          Tab(text: '🎮 Mini Game'),
        ],
      ),
    );
  }

  Widget _learn(bool compact) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 8, compact ? 12 : 18, 22),
      child: Column(
        children: [
          _letterShowcase(compact),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _navButton(icon: Icons.arrow_back_rounded, label: 'Sebelumnya', onTap: _previous, compact: compact)),
              const SizedBox(width: 12),
              Expanded(child: _navButton(icon: Icons.arrow_forward_rounded, label: 'Selanjutnya', trailing: true, onTap: _next, compact: compact)),
            ],
          ),
          const SizedBox(height: 18),
          _letterGrid(compact),
        ],
      ),
    );
  }

  Widget _letterShowcase(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(compact ? 16 : 24, compact ? 18 : 26, compact ? 16 : 24, compact ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              letter,
              key: ValueKey(letter),
              style: TextStyle(
                height: 1,
                fontSize: compact ? 132 : 165,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF24354A),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            letterName,
            style: TextStyle(
              fontSize: compact ? 27 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4E687D),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Huruf $letter',
            style: TextStyle(
              fontSize: compact ? 17 : 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF61798C),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: compact ? 230 : 270,
            height: compact ? 58 : 64,
            child: Material(
              color: const Color(0xFF42678F),
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => audio.speak('Huruf $letterName'),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Dengarkan',
                        style: TextStyle(color: Colors.white, fontSize: compact ? 20 : 23, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool compact,
    bool trailing = false,
  }) {
    final iconWidget = Icon(icon, color: Colors.white, size: compact ? 25 : 29);
    final labelWidget = Flexible(
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900)),
    );
    final children = trailing
        ? [labelWidget, const SizedBox(width: 7), iconWidget]
        : [iconWidget, const SizedBox(width: 7), labelWidget];

    return Material(
      color: const Color(0xFF42678F),
      borderRadius: BorderRadius.circular(24),
      elevation: 5,
      shadowColor: const Color(0x330D405C),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: SizedBox(height: compact ? 58 : 66, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children)),
      ),
    );
  }

  Widget _letterGrid(bool compact) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _letters.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: compact ? 8 : 12,
        mainAxisSpacing: compact ? 8 : 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        final selected = i == _index;
        return Material(
          color: selected ? const Color(0xFFFFD25C) : Colors.white.withValues(alpha: 0.93),
          borderRadius: BorderRadius.circular(20),
          elevation: selected ? 5 : 2,
          shadowColor: const Color(0x330D405C),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _select(i),
            child: Center(
              child: Text(
                _letters[i],
                style: TextStyle(fontSize: compact ? 25 : 31, fontWeight: FontWeight.w900, color: const Color(0xFF24354A)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _game(bool compact) {
    return StatefulBuilder(
      builder: (context, setGameState) {
        final targetIndex = _score % _letters.length;
        final target = _letters[targetIndex];
        final options = <String>[
          target,
          _letters[(targetIndex + 1) % _letters.length],
          _letters[(targetIndex + 2) % _letters.length],
          _letters[(targetIndex + 3) % _letters.length],
        ]..shuffle();

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 10, compact ? 12 : 18, 24),
          child: Column(
            children: [
              Text(
                '🧠 Pilih Huruf yang Benar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: compact ? 21 : 25, fontWeight: FontWeight.w900, color: const Color(0xFF31536D)),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.94), borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(target, style: TextStyle(fontSize: compact ? 110 : 140, height: 1, fontWeight: FontWeight.w900, color: const Color(0xFF24354A))),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 56,
                      child: Material(
                        color: const Color(0xFF42678F),
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => audio.speak('Pilih huruf $target'),
                          child: const Center(child: Text('🔊 Dengarkan Pertanyaan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.9,
                children: options.map((value) {
                  return Material(
                    color: const Color(0xFF42678F),
                    borderRadius: BorderRadius.circular(22),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        if (value == target) {
                          setGameState(() => _score++);
                          audio.correct();
                        } else {
                          audio.wrong();
                        }
                      },
                      child: Center(
                        child: Text(value, style: TextStyle(color: Colors.white, fontSize: compact ? 32 : 38, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Text(
                '⭐ Skor: $_score',
                style: TextStyle(fontSize: compact ? 24 : 29, fontWeight: FontWeight.w900, color: const Color(0xFF24354A)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roundControl({
    required double size,
    required IconData icon,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      elevation: 5,
      shadowColor: const Color(0x330D405C),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: size, height: size, child: Icon(icon, color: foreground, size: size * 0.52)),
      ),
    );
  }
}
