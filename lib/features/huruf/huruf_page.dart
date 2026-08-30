import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class HurufPage extends StatefulWidget {
  const HurufPage({super.key});

  @override
  State<HurufPage> createState() => _HurufPageState();
}

class _HurufPageState extends State<HurufPage> with SingleTickerProviderStateMixin {
  final AudioService audio = AudioService.instance;
  int _index = 0;
  late final TabController _tabs;

  static const _analogyEmoji = ['🏠','8️⃣','🌙','🪜','📘','🪮','🪝','🎢','🕯️','🪝','🔑','🦵','⛰️','🧲','⚽','🚩','🎈','🌈','🐍','☂️','🥣','✌️','🌊','❎','🪀','⚡'];
  static const _analogyText = ['Seperti atap rumah','Seperti dua perut gemuk','Seperti bulan sabit','Seperti pintu melengkung','Seperti sisir','Seperti sisir','Seperti kail','Seperti tangga','Seperti tiang atau lilin','Seperti kail','Seperti kunci','Seperti kaki meja','Seperti dua gunung','Seperti magnet','Seperti bola atau donat','Seperti tiang berbendera','Seperti balon berekor','Seperti pita melengkung','Seperti ular meliuk','Seperti payung','Seperti mangkok','Seperti ayunan','Seperti gelombang','Seperti dua garis menyilang','Seperti ketapel','Seperti kilat'];

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

  @override
  void initState() { super.initState(); _tabs = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  void _select(int index) {
    setState(() => _index = index);
    _speakCurrent();
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
              final w = constraints.maxWidth;
              final scale = (w / 868).clamp(0.70, 1.0);

              return Column(
                children: [
                  _header(w, scale),
                  _tabBar(w, scale),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(w * .035, 4, w * .035, 24),
                      child: Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * .74, child: TabBarView(controller: _tabs, children: [_lessonTab(w, scale, lowercase: false), _lessonTab(w, scale, lowercase: true), _quizTab(w, scale)])),
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

  Widget _header(double w, double scale) {
    final side = w * .125;
    final headerHeight = w * .19;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: w * .035,
            top: (headerHeight - side) / 2,
            child: _roundButton(
              size: side,
              color: const Color(0xFFFFC62E),
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            right: w * .035,
            top: (headerHeight - side) / 2,
            child: _roundButton(
              size: side,
              color: const Color(0xFF2DCA43),
              icon: Icons.music_note_rounded,
              onTap: () => audio.speak('Belajar Huruf. Mengenal Huruf A sampai Z.'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 54 * scale,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Belajar Huruf',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 54 * scale,
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
                  ),
                ),
                SizedBox(height: 2 * scale),
                SizedBox(
                  height: 30 * scale,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Mengenal Huruf A - Z',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 26 * scale,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _tabBar(double w, double scale) => TabBar(controller: _tabs, isScrollable: true, tabAlignment: TabAlignment.center, tabs: const [Tab(text: 'BESAR'), Tab(text: 'KECIL'), Tab(text: 'MINI KUIS')]);
  Widget _lessonTab(double w, double scale, {required bool lowercase}) => SingleChildScrollView(padding: EdgeInsets.fromLTRB(w * .035, 4, w * .035, 24), child: Column(children: [_lessonPanel(w, scale, lowercase: lowercase), SizedBox(height: 18 * scale), _pager(w, scale), SizedBox(height: 24 * scale), _alphabetPanel(w, scale, lowercase: lowercase)]));
  Widget _quizTab(double w, double scale) { final answer = _letters[_index]; final options = <String>{answer, _letters[(_index+1)%26], _letters[(_index+5)%26], _letters[(_index+10)%26]}.toList(); return Center(child: Container(margin: EdgeInsets.all(w*.05), padding: EdgeInsets.all(24*scale), decoration: BoxDecoration(color: Colors.white.withValues(alpha:.94), borderRadius: BorderRadius.circular(30)), child: Column(mainAxisSize: MainAxisSize.min, children: [Text('MINI KUIS', style: TextStyle(fontSize: 28*scale, fontWeight: FontWeight.w900)), const SizedBox(height: 10), Text('Pilih huruf untuk ${_words[_index]} ${_emoji[_index]}', textAlign: TextAlign.center), const SizedBox(height: 18), Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: options.map((x) => FilledButton(onPressed: () { if(x==answer){ audio.speak('Hebat, benar!'); _next(); } else { audio.speak('Coba lagi'); } }, child: Text(x, style: TextStyle(fontSize: 26*scale, fontWeight: FontWeight.w900)))).toList())]))); }

  Widget _lessonPanel(double w, double scale, {bool lowercase = false}) {
    final panelHeight = w * .78;
    final padding = w * .035;

    return Container(
      width: double.infinity,
      height: panelHeight,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1D8),
        borderRadius: BorderRadius.circular(34 * scale),
        border: Border.all(color: Colors.white.withValues(alpha: .85), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330A3B67),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Row(children: [
            Expanded(child: _wordCard(scale)),
            SizedBox(width: w * .025),
            Expanded(child: _letterCard(scale)),
          ])),
          SizedBox(height: 12 * scale),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 10 * scale),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(22 * scale)),
            child: Row(children: [
              Text(_analogyEmoji[_index], style: TextStyle(fontSize: 40 * scale)),
              SizedBox(width: 10 * scale),
              Expanded(child: Text('Bentuk ${_letters[_index]} ${_analogyText[_index]}', style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w900, color: const Color(0xFF31536D)))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _wordCard(double scale) {
    return Container(
      decoration: _whiteCardDecoration(scale),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _emoji[_index],
              key: ValueKey('emoji-$_index'),
              style: TextStyle(fontSize: 118 * scale),
            ),
          ),
          SizedBox(height: 14 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * scale),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _words[_index],
                maxLines: 1,
                style: TextStyle(
                  fontSize: 38 * scale,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF281A18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _letterCard(double scale) {
    return Container(
      decoration: _whiteCardDecoration(scale),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              lowercase ? _letters[_index].toLowerCase() : _letters[_index],
              key: ValueKey('letter-$_index-$lowercase'),
              style: TextStyle(
                fontSize: 180 * scale,
                height: .9,
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
          SizedBox(height: 28 * scale),
          Material(
            color: const Color(0xFF2DCA43),
            borderRadius: BorderRadius.circular(28 * scale),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(28 * scale),
              onTap: _speakCurrent,
              child: SizedBox(
                width: 130 * scale,
                height: 72 * scale,
                child: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 42 * scale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _whiteCardDecoration(double scale) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(30 * scale),
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

  Widget _pager(double w, double scale) {
    final button = w * .14;

    return Row(
      children: [
        _roundButton(
          size: button,
          color: const Color(0xFFFFC62E),
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: _previous,
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 34 * scale,
                vertical: 18 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF124B7B),
                borderRadius: BorderRadius.circular(28 * scale),
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
                  fontSize: 29 * scale,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        _roundButton(
          size: button,
          color: const Color(0xFFFFC62E),
          icon: Icons.arrow_forward_ios_rounded,
          onTap: _next,
        ),
      ],
    );
  }

  Widget _alphabetPanel(double w, double scale, {bool lowercase = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(34 * scale),
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
          crossAxisSpacing: 12 * scale,
          mainAxisSpacing: 16 * scale,
          childAspectRatio: .92,
        ),
        itemBuilder: (context, index) => _letterTile(index, scale, lowercase: lowercase),
      ),
    );
  }

  Widget _letterTile(int index, double scale, {bool lowercase = false}) {
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
      borderRadius: BorderRadius.circular(20 * scale),
      elevation: selected ? 7 : 4,
      shadowColor: const Color(0x55072440),
      child: InkWell(
        borderRadius: BorderRadius.circular(20 * scale),
        onTap: () => _select(index),
        child: Center(
          child: Text(
            lowercase ? _letters[index].toLowerCase() : _letters[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 36 * scale,
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
            size: size * .54,
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
