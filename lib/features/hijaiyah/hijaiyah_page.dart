import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class HijaiyahPage extends StatefulWidget {
  const HijaiyahPage({super.key});

  @override
  State<HijaiyahPage> createState() => _HijaiyahPageState();
}

class _HijaiyahPageState extends State<HijaiyahPage> with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  static const letters = [
    'ا','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص',
    'ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','هـ','و','ي',
  ];
  static const names = [
    'Alif','Ba','Ta','Tsa','Jim','Ha','Kha','Dal','Dzal','Ra','Zai','Sin','Syin','Shad',
    'Dhad','Tha','Zha','Ain','Ghain','Fa','Qaf','Kaf','Lam','Mim','Nun','Ha','Wau','Ya',
  ];
  int index = 0;
  late final TabController _tabs;

  @override
  void initState() { super.initState(); _tabs = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  List<int> get _gridOrder {
    final result = <int>[];
    for (var start = 0; start < letters.length; start += 7) {
      final end = start + 7 > letters.length ? letters.length : start + 7;
      for (var i = end - 1; i >= start; i--) {
        result.add(i);
      }
    }
    return result;
  }

  void select(int value) {
    setState(() => index = value);
    audio.speak('Huruf ${names[index]}');
  }

  @override
  Widget build(BuildContext context) {
    final item = letters[index];
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) {
              final w = box.maxWidth;
              final s = (w / 820).clamp(.72, 1.0);
              return Column(children: [
                  _header(w, s),
                  TabBar(controller: _tabs, isScrollable: true, tabAlignment: TabAlignment.center, tabs: const [Tab(text: 'HURUF'), Tab(text: 'KUIS MINI')]),
                  Expanded(child: TabBarView(controller: _tabs, children: [
                    SingleChildScrollView(padding: EdgeInsets.fromLTRB(w * .04, 8, w * .04, 24), child: Column(children: [
                  SizedBox(height: 14 * s),
                  Container(
                    height: w * .49,
                    padding: EdgeInsets.all(18 * s),
                    decoration: _panel(const Color(0xFFEEC6F1), s),
                    child: Row(children: [
                      Expanded(child: Container(
                        alignment: Alignment.center,
                        decoration: _card(s),
                        child: _centeredArabic(item, 176 * s, const Color(0xFF8A22C8), FontWeight.w800),
                      )),
                      SizedBox(width: 16 * s),
                      Expanded(child: Container(
                        decoration: _card(s),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(
                            height: 78 * s,
                            child: _centeredArabic(item, 72 * s, const Color(0xFF8A22C8), FontWeight.w900),
                          ),
                          SizedBox(height: 8 * s),
                          Text(names[index], style: TextStyle(fontSize: 34 * s, color: const Color(0xFF201B2A), fontWeight: FontWeight.w900)),
                          Text('"${names[index]}"', style: TextStyle(fontSize: 24 * s, color: const Color(0xFF8421B6), fontWeight: FontWeight.w800)),
                          SizedBox(height: 12 * s),
                          _soundButton(() => audio.speak(names[index]), s),
                        ]),
                      )),
                    ]),
                  ),
                  SizedBox(height: 14 * s),
                  Row(children: [
                    _round(w * .13, Icons.chevron_left_rounded, () { setState(() => index = (index - 1 + letters.length) % letters.length); }),
                    Expanded(child: Center(child: _counter('${index + 1} / ${letters.length}', s))),
                    _round(w * .13, Icons.chevron_right_rounded, () { setState(() => index = (index + 1) % letters.length); }),
                  ]),
                  SizedBox(height: 20 * s),
                  Container(
                    padding: EdgeInsets.all(16 * s),
                    decoration: _panel(Colors.white, s),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _gridOrder.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, crossAxisSpacing: 10 * s, mainAxisSpacing: 12 * s, childAspectRatio: .92),
                      itemBuilder: (context, displayIndex) {
                        final i = _gridOrder[displayIndex];
                        final palette = [const Color(0xFFE8B6F4), const Color(0xFFB9DCF5), const Color(0xFFB8F0D6), const Color(0xFFFFD0A5), const Color(0xFFC9C4F6), const Color(0xFFF5C1E5)];
                        return Material(
                          color: i == index ? const Color(0xFFE4A7F2) : palette[displayIndex % palette.length],
                          borderRadius: BorderRadius.circular(22 * s),
                          elevation: i == index ? 7 : 3,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22 * s),
                            onTap: () => select(i),
                            child: _centeredArabic(letters[i], 40 * s, Colors.black, FontWeight.w900),
                          ),
                        );
                      },
                    ),
                  ),
                ])),
                    _quizTab(w, s),
                  ])),
                ]);
            },
          ),
        ),
      ),
    );
  }


  Widget _quizTab(double w, double s) {
    final answer = letters[index];
    final options = <String>{answer, letters[(index + 1) % letters.length], letters[(index + 5) % letters.length], letters[(index + 10) % letters.length]}.toList();
    return Center(child: Container(margin: EdgeInsets.all(w * .06), padding: EdgeInsets.all(24 * s), decoration: _panel(Colors.white, s), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('MINI KUIS', style: TextStyle(fontSize: 28 * s, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Text('Pilih huruf \${names[index]}', style: TextStyle(fontSize: 21 * s, fontWeight: FontWeight.w800)),
      const SizedBox(height: 16),
      Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: options.map((x) => FilledButton(onPressed: () { if (x == answer) { audio.speak('Hebat, benar'); setState(() => index = (index + 1) % letters.length); } else { audio.speak('Coba lagi'); } }, child: Text(x, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 30 * s, fontWeight: FontWeight.w900)))).toList()),
    ])));
  }

  Widget _centeredArabic(String value, double fontSize, Color color, FontWeight weight) {
    return Center(
      child: Text(
        value,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        strutStyle: StrutStyle(
          fontSize: fontSize,
          height: 1,
          leading: 0,
          forceStrutHeight: true,
        ),
        style: TextStyle(
          fontSize: fontSize,
          height: 1,
          color: color,
          fontWeight: weight,
        ),
      ),
    );
  }

  Widget _header(double w, double s) => SizedBox(height: w * .16, child: Stack(alignment: Alignment.center, children: [
    Positioned(left: 0, child: _round(w * .12, Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
    Positioned(right: 0, child: _round(w * .12, Icons.music_note_rounded, () => audio.speak('Belajar Hijaiyah. Mengenal Huruf Arab'))),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .17),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Belajar Hijaiyah', maxLines: 1, style: TextStyle(fontSize: 40 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
        Text('Mengenal Huruf Arab', maxLines: 1, style: TextStyle(fontSize: 23 * s, color: Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 2, offset: Offset(1, 2))])),
      ]),
    ),
  ]));

  BoxDecoration _panel(Color color, double s) => BoxDecoration(color: color.withValues(alpha: .92), borderRadius: BorderRadius.circular(34 * s), border: Border.all(color: Colors.white.withValues(alpha: .8), width: 3), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 7))]);
  BoxDecoration _card(double s) => BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(28 * s), boxShadow: const [BoxShadow(color: Color(0x220D405C), blurRadius: 8, offset: Offset(0, 4))]);
  Widget _round(double size, IconData icon, VoidCallback onTap) => Material(color: icon == Icons.music_note_rounded ? const Color(0xFF29C63E) : const Color(0xFFFFC42D), shape: const CircleBorder(), elevation: 6, child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .56))));
  Widget _soundButton(VoidCallback onTap, double s) => Material(color: const Color(0xFF28C83E), borderRadius: BorderRadius.circular(28 * s), elevation: 5, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(28 * s), child: SizedBox(width: 100 * s, height: 64 * s, child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 39 * s))));
  Widget _counter(String text, double s) => Container(padding: EdgeInsets.symmetric(horizontal: 30 * s, vertical: 15 * s), decoration: BoxDecoration(color: const Color(0xFF174F7E), borderRadius: BorderRadius.circular(28 * s)), child: Text(text, style: TextStyle(color: Colors.white, fontSize: 28 * s, fontWeight: FontWeight.w900)));
}
