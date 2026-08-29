import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class HurufPage extends StatefulWidget {
  const HurufPage({super.key});

  @override
  State<HurufPage> createState() => _HurufPageState();
}

class _HurufPageState extends State<HurufPage> {
  final AudioService audio = AudioService.instance;
  int _index = 0;

  static const _letters = [
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  ];

  static const _words = [
    'Apel','Bola','Ceri','Domba','Elang','Foto','Gajah','Harimau',
    'Ikan','Jeruk','Kucing','Lampu','Mangga','Nanas','Orangutan',
    'Panda','Quran','Rusa','Singa','Topi','Ular','Vas','Wortel',
    'Xilofon','Yoyo','Zebra',
  ];

  static const _emoji = [
    '🍎','⚽','🍒','🐑','🦅','📷','🐘','🐯','🐟','🍊','🐱','💡',
    '🥭','🍍','🦧','🐼','📖','🦌','🦁','🎩','🐍','🏺','🥕','🎼',
    '🪀','🦓',
  ];

  void _select(int index) {
    setState(() => _index = index);
    audio.speak('Huruf ${_letters[index]}. ${_words[index]}');
  }

  void _previous() {
    setState(() => _index = (_index - 1 + _letters.length) % _letters.length);
    _speakCurrent();
  }

  void _next() {
    setState(() => _index = (_index + 1) % _letters.length);
    _speakCurrent();
  }

  void _speakCurrent() {
    audio.speak('Huruf ${_letters[_index]}. ${_words[_index]}');
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 10 : 16,
                        10,
                        compact ? 10 : 16,
                        24,
                      ),
                      child: Column(
                        children: [
                          _lessonPanel(compact),
                          const SizedBox(height: 14),
                          _pager(compact),
                          const SizedBox(height: 18),
                          _alphabetPanel(compact),
                        ],
                      ),
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
      padding: EdgeInsets.fromLTRB(compact ? 14 : 18, 12, compact ? 14 : 18, 6),
      child: Row(
        children: [
          _roundButton(
            size: side,
            color: const Color(0xFFFFC62E),
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Belajar Huruf',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: compact ? 31 : 38,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFD82F),
                    shadows: const [
                      Shadow(
                        color: Color(0xFF173A79),
                        blurRadius: 2,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mengenal Huruf A - Z',
                  style: TextStyle(
                    fontSize: compact ? 17 : 21,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF174981),
                        blurRadius: 2,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _roundButton(
            size: side,
            color: const Color(0xFF2DCA43),
            icon: Icons.music_note_rounded,
            onTap: () => audio.speak('Belajar Huruf. Mengenal Huruf A sampai Z.'),
          ),
        ],
      ),
    );
  }

  Widget _lessonPanel(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1D8),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330A3B67),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _wordCard(compact)),
          const SizedBox(width: compact ? 10 : 16),
          Expanded(child: _letterCard(compact)),
        ],
      ),
    );
  }

  Widget _wordCard(bool compact) {
    return Container(
      height: compact ? 250 : 310,
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: _whiteCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _emoji[_index],
              key: ValueKey('emoji-$_index'),
              style: TextStyle(fontSize: compact ? 92 : 120),
            ),
          ),
          const SizedBox(height: compact ? 10 : 14),
          Text(
            _words[_index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 26 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF281A18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _letterCard(bool compact) {
    return Container(
      height: compact ? 250 : 310,
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: _whiteCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _letters[_index],
              key: ValueKey('letter-$_index'),
              style: TextStyle(
                fontSize: compact ? 128 : 165,
                height: 0.9,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFF2638),
                shadows: const [
                  Shadow(
                    color: Color(0x99200000),
                    blurRadius: 2,
                    offset: Offset(1, 3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: compact ? 24 : 30),
          Material(
            color: const Color(0xFF2DCA43),
            borderRadius: BorderRadius.circular(26),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: _speakCurrent,
              child: SizedBox(
                width: compact ? 104 : 124,
                height: compact ? 58 : 68,
                child: const Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _whiteCardDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFFF2E5D5), width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x220C355C),
          blurRadius: 9,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  Widget _pager(bool compact) {
    return Row(
      children: [
        _roundButton(
          size: compact ? 82 : 96,
          color: const Color(0xFFFFC62E),
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: _previous,
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 24 : 30,
                vertical: compact ? 14 : 17,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF124B7B),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x330A3156),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '${_index + 1} / 26',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 22 : 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        _roundButton(
          size: compact ? 82 : 96,
          color: const Color(0xFFFFC62E),
          icon: Icons.arrow_forward_ios_rounded,
          onTap: _next,
        ),
      ],
    );
  }

  Widget _alphabetPanel(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330A3B67),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _letters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: compact ? 8 : 12,
          mainAxisSpacing: compact ? 12 : 16,
          childAspectRatio: 0.92,
        ),
        itemBuilder: (context, index) {
          return _letterTile(index, compact);
        },
      ),
    );
  }

  Widget _letterTile(int index, bool compact) {
    const colors = [
      Color(0xFFFF3044), Color(0xFFFF8B0A), Color(0xFFFFC62E),
      Color(0xFF31C842), Color(0xFF2399D8), Color(0xFF4655D6),
      Color(0xFF783DD2), Color(0xFFAE2AC8), Color(0xFFFF542D),
      Color(0xFFFFB312), Color(0xFF2FC83B), Color(0xFF3964D9),
      Color(0xFF6341D4),
    ];
    final selected = index == _index;
    final color = selected ? const Color(0xFFFF2638) : colors[index % colors.length];

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(compact ? 16 : 20),
      elevation: selected ? 7 : 4,
      shadowColor: const Color(0x55072440),
      child: InkWell(
        borderRadius: BorderRadius.circular(compact ? 16 : 20),
        onTap: () => _select(index),
        child: Center(
          child: Text(
            _letters[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 27 : 34,
              fontWeight: FontWeight.w900,
              shadows: const [
                Shadow(
                  color: Color(0x55000000),
                  blurRadius: 2,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundButton({
    required double size,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: const Color(0x55082443),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: Colors.white,
            size: size * 0.54,
            shadows: const [
              Shadow(
                color: Color(0x55000000),
                blurRadius: 2,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
