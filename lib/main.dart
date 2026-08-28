import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const IrkopBelajarApp());

class IrkopBelajarApp extends StatelessWidget {
  const IrkopBelajarApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bermain Sambil Belajar',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
        home: const HomeScreen(),
      );
}

class SoundService {
  SoundService._();
  static final instance = SoundService._();
  final FlutterTts tts = FlutterTts();
  final AudioPlayer music = AudioPlayer();
  final AudioPlayer fx = AudioPlayer();
  bool voiceOn = true;
  bool musicOn = true;

  Future<void> init() async {
    await tts.setLanguage('id-ID');
    await tts.setSpeechRate(.42);
    await tts.setPitch(1.15);
    final p = await SharedPreferences.getInstance();
    voiceOn = p.getBool('voiceOn') ?? true;
    musicOn = p.getBool('musicOn') ?? true;
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('voiceOn', voiceOn);
    await p.setBool('musicOn', musicOn);
  }

  Future<void> speak(String text) async {
    if (!voiceOn) return;
    await tts.stop();
    await tts.speak(text);
  }

  Future<void> click(String text) async {
    await speak(text);
    if (voiceOn) await fx.play(AssetSource('audio/click.wav'));
  }

  Future<void> correct() async {
    await fx.play(AssetSource('audio/correct.wav'));
    await speak('Hebat! Jawabanmu benar!');
  }

  Future<void> wrong() async {
    await fx.play(AssetSource('audio/wrong.wav'));
    await speak('Aduh, jawabanmu belum tepat. Coba lagi ya!');
  }

  Future<void> setMusic(bool value) async {
    musicOn = value;
    await save();
    if (value) {
      await music.setReleaseMode(ReleaseMode.loop);
      await music.play(AssetSource('audio/backsound.wav'), volume: .18);
    } else {
      await music.stop();
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final s = SoundService.instance;
  bool ready = false;
  @override void initState() { super.initState(); _init(); }
  Future<void> _init() async { await s.init(); if (s.musicOn) await s.setMusic(true); setState(() => ready = true); }

  void open(Widget page, String label) async {
    await s.click(label);
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('ABC', 'HURUF', const LettersScreen(), const Color(0xff4CAF50), '🔤'),
      ('123', 'ANGKA', const NumbersScreen(), const Color(0xff2196F3), '🔢'),
      ('ث', 'HIJAIYAH', const HijaiyahScreen(), const Color(0xff7E57C2), '🕌'),
      ('🍎', 'GAMBAR', const PictureScreen(), const Color(0xffF9A825), '🖼️'),
      ('🎨', 'WARNA', const ColorsScreen(), const Color(0xffff7043), '🌈'),
      ('🖍️', 'MEWARNAI', const ColoringScreen(), const Color(0xff26A69A), '🖍️'),
      ('🏆', 'KUIS', const QuizScreen(), const Color(0xff3949AB), '❓'),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors:[Color(0xff73d8ff),Color(0xffe9f7ff)])),
        child: SafeArea(child: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 900;
          return SingleChildScrollView(padding: const EdgeInsets.all(18), child: Column(children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('BERMAIN', style: TextStyle(fontSize: 42,fontWeight: FontWeight.w900,color: Color(0xffef3f61),height:.9)),
                const Text('SAMBIL', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Color(0xffff8c1a)),),
                const Text('BELAJAR', style: TextStyle(fontSize: 42,fontWeight: FontWeight.w900,color: Color(0xff2868d8),height:.9)),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.symmetric(horizontal:14,vertical:8),decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(20)),child: const Text('Belajar Jadi Menyenangkan!',style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold))),
              ])),
              Column(children: [
                Row(children: [
                  _TopToggle(icon: Icons.volume_up, label:'Suara', value:s.voiceOn, onTap: () async {setState(()=>s.voiceOn=!s.voiceOn); await s.save(); if(s.voiceOn) await s.speak('Suara aktif');}),
                  const SizedBox(width:10),
                  _TopToggle(icon: Icons.music_note, label:'Musik', value:s.musicOn, onTap: () async {await s.setMusic(!s.musicOn); setState((){});}),
                ]),
                const SizedBox(height:10),
                const Text('🌈  ⭐  ☁️', style: TextStyle(fontSize:28)),
              ]),
            ]),
            const SizedBox(height:18),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: wide?7:10, child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color:Colors.white.withOpacity(.35),borderRadius:BorderRadius.circular(30)), child: GridView.count(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(),crossAxisCount:wide?4:2,mainAxisSpacing:14,crossAxisSpacing:14,childAspectRatio:1.05,children:cards.map((x)=>_MenuCard(top:x.$1,title:x.$2,color:x.$4,emoji:x.$5,onTap:()=>open(x.$3,x.$2))).toList()))),
              if (wide) const SizedBox(width:16),
              if (wide) Expanded(flex:3, child: _FeaturePanel(onTap:()=>s.speak('Semua ada suara. Backsound bisa dinyalakan atau dimatikan.'))),
            ]),
            const SizedBox(height:18),
            if (wide) _CharacterRow() else const SizedBox.shrink(),
            if (!ready) const Padding(padding:EdgeInsets.all(20),child:CircularProgressIndicator()),
          ]));
        })),
      ),
    );
  }
}

class _TopToggle extends StatelessWidget { final IconData icon; final String label; final bool value; final VoidCallback onTap; const _TopToggle({required this.icon,required this.label,required this.value,required this.onTap}); @override Widget build(BuildContext c)=>GestureDetector(onTap:onTap,child:Container(width:82,padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.12),blurRadius:8)]),child:Column(children:[Icon(icon,size:30,color:Colors.deepOrange),Text(label,style:const TextStyle(fontWeight:FontWeight.bold)),Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),decoration:BoxDecoration(color:value?Colors.green:Colors.grey,borderRadius:BorderRadius.circular(10)),child:Text(value?'ON':'OFF',style:const TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.bold)))]))); }
class _MenuCard extends StatelessWidget { final String top,title,emoji; final Color color; final VoidCallback onTap; const _MenuCard({required this.top,required this.title,required this.color,required this.emoji,required this.onTap}); @override Widget build(BuildContext c)=>TweenAnimationBuilder<double>(tween:Tween(begin:1,end:1),duration:const Duration(milliseconds:400),builder:(c,v,_)=>GestureDetector(onTap:onTap,child:Container(decoration:BoxDecoration(gradient:LinearGradient(colors:[color,color.withOpacity(.72)]),borderRadius:BorderRadius.circular(24),boxShadow:[BoxShadow(color:color.withOpacity(.3),blurRadius:10,offset:const Offset(0,6))]),child:Stack(children:[Positioned(right:8,top:8,child:Text(emoji,style:const TextStyle(fontSize:26))),Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text(top,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:Colors.white)),const SizedBox(height:8),Text(title,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w900,color:Colors.white))]))])))); }
class _FeaturePanel extends StatelessWidget { final VoidCallback onTap; const _FeaturePanel({required this.onTap}); @override Widget build(BuildContext c)=>GestureDetector(onTap:onTap,child:Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white.withOpacity(.85),borderRadius:BorderRadius.circular(26)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('FITUR UTAMA',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:Color(0xff5833b9))),SizedBox(height:14),_Feature(icon:'🔊',title:'Semua ada suara',body:'Setiap interaksi memiliki audio.'),_Feature(icon:'🎵',title:'Backsound On/Off',body:'Atur musik sesuai keinginan.'),_Feature(icon:'⭐',title:'Visual Lucu & Menarik',body:'Karakter dan efek ceria.'),_Feature(icon:'🎉',title:'Belajar Sambil Bermain',body:'Aktivitas interaktif untuk anak.'),_Feature(icon:'📊',title:'Progress Belajar',body:'Pantau perkembangan belajar.')]))); }
class _Feature extends StatelessWidget { final String icon,title,body; const _Feature({required this.icon,required this.title,required this.body}); @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(icon,style:const TextStyle(fontSize:26)),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w800)),Text(body)]))])); }
class _CharacterRow extends StatelessWidget { @override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white.withOpacity(.7),borderRadius:BorderRadius.circular(24)),child:const Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Text('🧒',style:TextStyle(fontSize:50)),Text('👧',style:TextStyle(fontSize:50)),Text('🐲',style:TextStyle(fontSize:50)),Text('🐧',style:TextStyle(fontSize:50)),Text('🐱',style:TextStyle(fontSize:50)),Text('🐼',style:TextStyle(fontSize:50)),Text('🦁',style:TextStyle(fontSize:50))])); }

class LearnShell extends StatelessWidget { final String title; final Color color; final Widget child; const LearnShell({super.key,required this.title,required this.color,required this.child}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(title,style:const TextStyle(fontWeight:FontWeight.w900)),backgroundColor:color,foregroundColor:Colors.white,actions:[IconButton(onPressed:()=>SoundService.instance.speak(title),icon:const Icon(Icons.volume_up))]),body:Container(color:color.withOpacity(.10),child:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:760),child:Padding(padding:const EdgeInsets.all(20),child:child)))))); }

class LettersScreen extends StatelessWidget { const LettersScreen({super.key}); @override Widget build(BuildContext c)=>LearnShell(title:'HURUF',color:Colors.green,child:_LetterContent()); }
class _LetterContent extends StatefulWidget { @override State<_LetterContent> createState()=>_LetterContentState(); }
class _LetterContentState extends State<_LetterContent>{ int i=0; final data=[('A','Apel','🍎'),('B','Bola','⚽'),('C','Ceri','🍒'),('D','Dadu','🎲')]; void next() async {setState(()=>i=(i+1)%data.length); await SoundService.instance.speak('${data[i].$1}, ${data[i].$2}');} @override Widget build(BuildContext c){final d=data[i];return Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(d.$1,style:const TextStyle(fontSize:150,fontWeight:FontWeight.w900,color:Colors.red)),Text(d.$3,style:const TextStyle(fontSize:80)),Text(d.$2,style:const TextStyle(fontSize:32,fontWeight:FontWeight.w800)),const SizedBox(height:25),ElevatedButton.icon(onPressed:next,icon:const Icon(Icons.volume_up),label:const Text('DENGARKAN & LANJUT'))]);}}
class NumbersScreen extends StatelessWidget { const NumbersScreen({super.key}); @override Widget build(BuildContext c)=>LearnShell(title:'ANGKA',color:Colors.blue,child:_NumberContent()); }
class _NumberContent extends StatefulWidget { @override State<_NumberContent> createState()=>_NumberContentState(); }
class _NumberContentState extends State<_NumberContent>{int n=3;void next()async{setState(()=>n=n==5?1:n+1);await SoundService.instance.speak('$n');} @override Widget build(BuildContext c)=>Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('$n',style:const TextStyle(fontSize:150,fontWeight:FontWeight.w900,color:Colors.green)),Text('🍎 '*n,style:const TextStyle(fontSize:42)),Text(['','Satu','Dua','Tiga','Empat','Lima'][n],style:const TextStyle(fontSize:32,fontWeight:FontWeight.w800)),const SizedBox(height:25),ElevatedButton.icon(onPressed:next,icon:const Icon(Icons.volume_up),label:const Text('DENGARKAN & LANJUT'))]);}
class HijaiyahScreen extends StatelessWidget { const HijaiyahScreen({super.key}); @override Widget build(BuildContext c)=>LearnShell(title:'HIJAIYAH',color:Colors.deepPurple,child:_HijContent()); }
class _HijContent extends StatefulWidget { @override State<_HijContent> createState()=>_HijContentState(); }
class _HijContentState extends State<_HijContent>{int i=0;final a=[('ا','Alif'),('ب','Ba'),('ت','Ta'),('ث','Tsa')];void next()async{setState(()=>i=(i+1)%a.length);await SoundService.instance.speak(a[i].$2);} @override Widget build(BuildContext c)=>Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(a[i].$1,style:const TextStyle(fontSize:150,fontWeight:FontWeight.w900)),Text(a[i].$2,style:const TextStyle(fontSize:32,fontWeight:FontWeight.w800)),const SizedBox(height:25),ElevatedButton.icon(onPressed:next,icon:const Icon(Icons.volume_up),label:const Text('DENGARKAN & LANJUT'))]);}
class PictureScreen extends StatelessWidget { const PictureScreen({super.key}); @override Widget build(BuildContext c)=>LearnShell(title:'GAMBAR',color:Colors.orange,child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Text('🍎',style:TextStyle(fontSize:150)),const Text('Apel',style:TextStyle(fontSize:38,fontWeight:FontWeight.w900)),const SizedBox(height:20),ElevatedButton.icon(onPressed:()=>SoundService.instance.speak('Apel'),icon:const Icon(Icons.volume_up),label:const Text('DENGARKAN'))])); }

class ColorsScreen extends StatefulWidget { const ColorsScreen({super.key}); @override State<ColorsScreen> createState()=>_ColorsScreenState(); }
class _ColorsScreenState extends State<ColorsScreen>{Color bg=const Color(0xfffff3cf);String name='Pilih salah satu warna';final colors=[('Merah',Colors.red),('Biru',Colors.blue),('Kuning',Colors.amber),('Hijau',Colors.green),('Ungu',Colors.purple),('Jingga',Colors.orange),('Pink',Colors.pink),('Cokelat',Colors.brown)];void choose(String n,Color c)async{setState(() { bg = c.withOpacity(.28); name = n; });await SoundService.instance.speak(n);} @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('WARNA',style:TextStyle(fontWeight:FontWeight.w900)),backgroundColor:Colors.orange,foregroundColor:Colors.white),body:AnimatedContainer(duration:const Duration(milliseconds:450),color:bg,child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:700),child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(name,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),const SizedBox(height:25),Wrap(spacing:14,runSpacing:14,alignment:WrapAlignment.center,children:colors.map((x)=>GestureDetector(onTap:()=>choose(x.$1,x.$2),child:Container(width:88,height:88,decoration:BoxDecoration(color:x.$2,shape:BoxShape.circle,boxShadow:[BoxShadow(color:Colors.black.withOpacity(.15),blurRadius:8)]),child:Center(child:Text(x.$1,style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:13)))))).toList()),const SizedBox(height:25),const Text('Klik warna → background ikut berubah!',style:TextStyle(fontWeight:FontWeight.w700))])))))); }

class ColoringScreen extends StatefulWidget { const ColoringScreen({super.key}); @override State<ColoringScreen> createState()=>_ColoringScreenState(); }
class _ColoringScreenState extends State<ColoringScreen>{Color body=Colors.white;final palette=[Colors.red,Colors.orange,Colors.amber,Colors.green,Colors.cyan,Colors.blue,Colors.purple,Colors.pink];void paint(Color c)async{setState(()=>body=c);await SoundService.instance.speak('Mewarnai');} @override Widget build(BuildContext c)=>LearnShell(title:'MEWARNAI',color:Colors.teal,child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[GestureDetector(onTap:()=>paint(body==Colors.white?Colors.pink:Colors.white),child:AnimatedContainer(duration:const Duration(milliseconds:300),width:310,height:310,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(40),border:Border.all(width:4)),child:Center(child:Text('🐱',style:TextStyle(fontSize:210,color:body))))),const SizedBox(height:22),Wrap(spacing:10,children:palette.map((x)=>GestureDetector(onTap:()=>paint(x),child:Container(width:38,height:38,decoration:BoxDecoration(color:x,shape:BoxShape.circle,border:Border.all(width:2,color:Colors.white))))).toList()),const SizedBox(height:14),const Text('Pilih warna lalu sentuh gambar',style:TextStyle(fontWeight:FontWeight.w700))]));}

class QuizScreen extends StatefulWidget { const QuizScreen({super.key}); @override State<QuizScreen> createState()=>_QuizScreenState(); }
class _QuizScreenState extends State<QuizScreen>{int score=0;bool answered=false;String message='Pilih jawabanmu!';final opts=['2','3','4'];Future<void> answer(String v)async{if(answered)return;setState(()=>answered=true);if(v=='3'){setState(() { score += 10; message = 'Hebat! Jawabanmu benar!'; });await SoundService.instance.correct();}else{setState(()=>message='Aduh, coba lagi ya!');await SoundService.instance.wrong();}Future.delayed(const Duration(milliseconds:900),()=>mounted?setState(()=>answered=false):null);} @override Widget build(BuildContext c)=>LearnShell(title:'KUIS',color:Colors.indigo,child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Align(alignment:Alignment.centerRight,child:Text('⭐ $score',style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900))),const Text('Berapakah jumlah apel?',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:10),const Text('🍎  🍎  🍎',style:TextStyle(fontSize:65)),const SizedBox(height:22),Wrap(spacing:14,children:opts.map((v)=>SizedBox(width:100,height:62,child:ElevatedButton(onPressed:()=>answer(v),child:Text(v,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900))))).toList()),const SizedBox(height:22),AnimatedSwitcher(duration:const Duration(milliseconds:250),child:Text(message,key:ValueKey(message),style:TextStyle(fontSize:24,fontWeight:FontWeight.w900,color:message.startsWith('Hebat')?Colors.green:Colors.red)))]));}
