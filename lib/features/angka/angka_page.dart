import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class AngkaPage extends StatefulWidget {
  const AngkaPage({super.key});

  @override
  State<AngkaPage> createState() => _AngkaPageState();
}

class _AngkaPageState extends State<AngkaPage>
    with SingleTickerProviderStateMixin {
  final AudioService audio = AudioService.instance;

  late final TabController _tabs;
  int _index = 0;
  int _score = 0;

  static const _arabicNumbers = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠'];
  static const _analogyEmoji = ['✏️','🐍','🐦','🪑','🤡','🐍','🦯','🥜','🎈','🏑⚽'];
  static const _analogyText = ['Seperti pensil atau lilin','Seperti ular yang meliuk','Seperti burung terbang','Seperti kursi terbalik','Seperti badut','Seperti ular yang melingkar','Seperti tongkat nenek','Seperti kacang','Seperti balon terbang','Seperti lidi dan bola'];

  static const _numberWords = [
    'Satu',
    'Dua',
    'Tiga',
    'Empat',
    'Lima',
    'Enam',
    'Tujuh',
    'Delapan',
    'Sembilan',
    'Sepuluh',
  ];

  int get number => _index + 1;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => audio.speak('Angka $number'),
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _select(int value) {
    setState(() => _index = value);
    audio.speak('Angka ${value + 1}');
  }

  void _previous() {
    setState(() => _index = (_index - 1 + 10) % 10);
    audio.speak('Angka $number');
  }

  void _next() {
    setState(() => _index = (_index + 1) % 10);
    audio.speak('Angka $number');
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
                      children: [
                        _learn(compact),
                        _learn(compact, arabic: true),
                        _game(compact),
                      ],
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
                  BoxShadow(
                    color: Color(0x330D405C),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dunia Angka 🔢',
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
                    'Belajar angka sambil bermain',
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
            onTap: () => audio.speak('Dunia Angka. Belajar angka sambil bermain.'),
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
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: compact ? 5 : 6,
            color: const Color(0xFF31536D),
          ),
          insets: const EdgeInsets.symmetric(horizontal: 24),
        ),
        labelColor: const Color(0xFF31536D),
        unselectedLabelColor: const Color(0xFF61798C),
        labelStyle: TextStyle(
          fontSize: compact ? 14 : 16,
          fontWeight: FontWeight.w900,
        ),
        tabs: const [
          Tab(text: 'ANGKA ID'),
          Tab(text: 'ANGKA ARAB'),
          Tab(text: 'KUIS MINI'),
        ],
      ),
    );
  }

  Widget _learn(bool compact, {bool arabic = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 8, compact ? 12 : 18, 22),
      child: Column(
        children: [
          _numberShowcase(compact, arabic: arabic),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _navButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Sebelumnya',
                  onTap: _previous,
                  compact: compact,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _navButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Selanjutnya',
                  trailing: true,
                  onTap: _next,
                  compact: compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _numberGrid(compact, arabic: arabic),
        ],
      ),
    );
  }

  Widget _numberShowcase(bool compact, {bool arabic = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 24,
        compact ? 18 : 26,
        compact ? 16 : 24,
        compact ? 18 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330D405C),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              arabic ? _arabicNumbers[_index] : '$number',
              key: ValueKey('${number}-$arabic'),
              style: TextStyle(
                height: 1,
                fontSize: compact ? 122 : 150,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF24354A),
                shadows: const [
                  Shadow(
                    color: Color(0x220D405C),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _numberWords[_index],
            style: TextStyle(
              fontSize: compact ? 27 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4E687D),
            ),
          ),
          const SizedBox(height: 14),
          _countVisual(compact),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF4F8FB), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Text(_analogyEmoji[_index], style: TextStyle(fontSize: compact ? 36 : 44)),
              const SizedBox(width: 10),
              Expanded(child: Text(_analogyText[_index], style: TextStyle(fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900, color: const Color(0xFF42678F)))),
            ]),
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
                onTap: () => audio.speak('Angka $number. ${_numberWords[_index]}'),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Dengarkan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 20 : 23,
                          fontWeight: FontWeight.w900,
                        ),
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

  Widget _countVisual(bool compact) {
    final itemSize = compact ? 30.0 : 36.0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: compact ? 5 : 7,
      runSpacing: compact ? 5 : 7,
      children: List.generate(
        number,
        (i) => SizedBox(
          width: itemSize,
          height: itemSize,
          child: const FittedBox(child: Text('⭐')),
        ),
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
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 15 : 18,
          fontWeight: FontWeight.w900,
        ),
      ),
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
        child: SizedBox(
          height: compact ? 58 : 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _numberGrid(bool compact, {bool arabic = false}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
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
                arabic ? _arabicNumbers[i] : '${i + 1}',
                style: TextStyle(
                  fontSize: compact ? 26 : 31,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF24354A),
                ),
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
        final target = (_score % 10) + 1;
        final options = <int>[
          target,
          target == 10 ? 9 : target + 1,
          target == 1 ? 2 : target - 1,
          target <= 7 ? target + 3 : target - 3,
        ]..shuffle();

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 10, compact ? 12 : 18, 24),
          child: Column(
            children: [
              Text(
                '🧠 Pilih Jawaban yang Benar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: compact ? 21 : 25,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF31536D),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    _countVisualFor(target, compact),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 56,
                      child: Material(
                        color: const Color(0xFF42678F),
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => audio.speak('Ada berapa bintang?'),
                          child: const Center(
                            child: Text(
                              '🔊 Dengarkan Pertanyaan',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...options.map(
                (value) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: compact ? 58 : 66,
                    child: Material(
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
                          child: Text(
                            '$value',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: compact ? 23 : 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '⭐ Skor: $_score',
                style: TextStyle(
                  fontSize: compact ? 24 : 29,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF24354A),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _countVisualFor(int value, bool compact) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: compact ? 7 : 10,
      runSpacing: compact ? 7 : 10,
      children: List.generate(
        value,
        (_) => Text('⭐', style: TextStyle(fontSize: compact ? 34 : 42)),
      ),
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
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: foreground, size: size * 0.52),
        ),
      ),
    );
  }
}
