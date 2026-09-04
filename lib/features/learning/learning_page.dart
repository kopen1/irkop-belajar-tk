import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/web_3d_visual.dart';

enum LearningType { huruf, angka, hijaiyah, gambar, warna }

class LearningPage extends StatefulWidget {
  final LearningType type;
  const LearningPage({super.key, required this.type});
  @override State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  final random = Random();
  late final TabController tabs;
  int index = 0, score = 0, qPos = 0;
  late List<int> deck;
  late Item question;
  late List<Item> options;

  static const letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
  static const words = ['Apel','Bola','Ceri','Domba','Elang','Foto','Gajah','Harimau','Ikan','Jeruk','Kucing','Lampu','Mangga','Nanas','Orangutan','Panda','Quran','Rusa','Singa','Topi','Ular','Vas','Wortel','Xilofon','Yoyo','Zebra'];
  static const pics = ['🍎','⚽','🍒','🐑','🦅','📷','🐘','🐯','🐟','🍊','🐱','💡','🥭','🍍','🦧','🐼','📖','🦌','🦁','🎩','🐍','🏺','🥕','🎼','🪀','🦓'];
  static const numberWords = ['Satu','Dua','Tiga','Empat','Lima','Enam','Tujuh','Delapan','Sembilan','Sepuluh'];
  static const numberHints = ['Seperti pensil atau lilin.','Seperti ular yang meliuk.','Seperti burung yang terbang.','Seperti kursi terbalik.','Seperti badut.','Seperti ular yang melingkar.','Seperti tongkat nenek.','Seperti kacang atau kacamata.','Seperti balon terbang.','Seperti lidi dan bola.'];
  static const hij = [('ا','Alif'),('ب','Ba'),('ت','Ta'),('ث','Tsa'),('ج','Jim'),('ح','Ha'),('خ','Kha'),('د','Dal'),('ذ','Dzal'),('ر','Ra'),('ز','Zai'),('س','Sin'),('ش','Syin'),('ص','Shad'),('ض','Dhad'),('ط','Tha'),('ظ','Zha'),('ع','Ain'),('غ','Ghain'),('ف','Fa'),('ق','Qaf'),('ك','Kaf'),('ل','Lam'),('م','Mim'),('ن','Nun'),('هـ','Ha'),('و','Wau'),('ي','Ya')];
  static const imageItems = [('🐱','Kucing'),('🐶','Anjing'),('🐘','Gajah'),('🦁','Singa'),('🐟','Ikan'),('🍎','Apel'),('🍌','Pisang'),('🚗','Mobil'),('🏠','Rumah'),('⚽','Bola'),('🌞','Matahari'),('🌈','Pelangi')];
  static const colorItems = [('🔴','Merah'),('🔵','Biru'),('🟡','Kuning'),('🟢','Hijau'),('🟣','Ungu'),('🟠','Oranye'),('🩷','Merah Muda'),('🟤','Cokelat')];

  List<Item> get items {
    switch (widget.type) {
      case LearningType.huruf:
        return List.generate(26, (i) {
          final hint = {'A':'Seperti atap rumah atau gunung.','B':'Seperti dua perut gemuk bertumpuk.','C':'Seperti bulan sabit.','I':'Seperti tiang listrik atau lilin.','L':'Seperti kaki meja.','O':'Seperti bola, roda, atau donat.','S':'Seperti ular yang meliuk-liuk.','U':'Seperti mangkok atau ayunan.'}[letters[i]] ?? 'Kenali bentuk huruf ini.';
          return Item(letters[i], pics[i], words[i], hint);
        });
      case LearningType.angka:
        return List.generate(10, (i) => Item((i+1).toString(), List.filled(i+1,'⭐').join(' '), numberWords[i], numberHints[i]));
      case LearningType.hijaiyah:
        return hij.map((e) => Item(e.$1, e.$1, e.$2, 'Ulangi bunyi ' + e.$2 + ' sambil mengenali bentuknya.')).toList();
      case LearningType.gambar:
        return imageItems.map((e) => Item(e.$2,e.$1,e.$2,'Ini adalah gambar ' + e.$2 + '.')).toList();
      case LearningType.warna:
        return colorItems.map((e) => Item(e.$2,e.$1,e.$2,'Ini adalah warna ' + e.$2 + '.')).toList();
    }
  }

  int get tabCount => (widget.type == LearningType.huruf || widget.type == LearningType.angka) ? 3 : 2;
  List<String> get tabNames {
    switch(widget.type) {
      case LearningType.huruf: return ['BESAR','KECIL','MINI KUIS'];
      case LearningType.angka: return ['ANGKA ID','ANGKA ARAB','KUIS MINI'];
      case LearningType.hijaiyah: return ['HURUF','KUIS MINI'];
      case LearningType.gambar: return ['GAMBAR','KUIS MINI'];
      case LearningType.warna: return ['WARNA','KUIS MINI'];
    }
  }
  String get title {
    switch(widget.type) {
      case LearningType.huruf: return 'Belajar Huruf';
      case LearningType.angka: return 'Belajar Angka';
      case LearningType.hijaiyah: return 'Belajar Hijaiyah';
      case LearningType.gambar: return 'Belajar Gambar';
      case LearningType.warna: return 'Belajar Warna';
    }
  }

  @override void initState() {
    super.initState();
    tabs = TabController(length: tabCount, vsync: this);
    deck = List.generate(items.length,(i)=>i)..shuffle(random);
    loadQuestion();
  }
  @override void dispose(){ tabs.dispose(); super.dispose(); }

  void loadQuestion() {
    if (qPos >= deck.length) { deck.shuffle(random); qPos = 0; }
    question = items[deck[qPos]];
    final wrong = [...items]..removeWhere((x)=>x.title==question.title)..shuffle(random);
    options = [question,...wrong.take(2)]..shuffle(random);
  }
  void nextQuestion() {
    setState(() { qPos++; loadQuestion(); });
    audio.question('Mana ' + question.title + '?');
  }
  void choose(Item item) {
    if(item.title == question.title) {
      setState(()=>score++);
      audio.correct();
      Future.delayed(const Duration(milliseconds:650), nextQuestion);
    } else { audio.wrong(); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    body: KidBackground(child: SafeArea(child: Column(children:[
      Padding(padding:const EdgeInsets.all(12),child:Row(children:[
        _round(Icons.arrow_back_rounded,const Color(0xFFFFC42D),()=>Navigator.of(context).maybePop()),
        Expanded(child:Column(children:[
          Text(title,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900,color:Color(0xFFFFD32F),shadows:[Shadow(color:Color(0xFF17417B),blurRadius:3,offset:Offset(2,3))])),
          const Text('Belajar sambil bermain',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w800)),
        ])),
        _round(Icons.volume_up_rounded,const Color(0xFF29C63E),()=>audio.speak(title)),
      ])),
      Container(margin:const EdgeInsets.symmetric(horizontal:12),decoration:BoxDecoration(color:Colors.white.withValues(alpha:.92),borderRadius:BorderRadius.circular(20)),
        child:TabBar(controller:tabs,isScrollable:tabCount==3,tabAlignment:tabCount==3?TabAlignment.center:TabAlignment.fill,dividerColor:Colors.transparent,
          indicator:BoxDecoration(color:const Color(0xFF2D98C8),borderRadius:BorderRadius.circular(18)),indicatorSize:TabBarIndicatorSize.tab,
          labelColor:Colors.white,unselectedLabelColor:const Color(0xFF52677A),labelStyle:const TextStyle(fontWeight:FontWeight.w900,fontSize:13),
          tabs:tabNames.map((x)=>Tab(text:x)).toList())),
      Expanded(child:TabBarView(controller:tabs,children:List.generate(tabCount,tabView))),
    ]))),
  );

  Widget _round(IconData icon,Color color,VoidCallback onTap)=>Material(color:color,shape:const CircleBorder(),elevation:5,child:InkWell(customBorder:const CircleBorder(),onTap:onTap,child:SizedBox(width:56,height:56,child:Icon(icon,color:Colors.white,size:31))));

  Widget tabView(int tab) {
    if(tab==tabCount-1) return quiz();
    return learn(widget.type==LearningType.huruf&&tab==1,widget.type==LearningType.angka&&tab==1);
  }

  Widget learn(bool lower,bool arab) {
    final item=items[index];
    final display=widget.type==LearningType.huruf&&lower?item.title.toLowerCase():widget.type==LearningType.angka&&arab?arabic(index+1):item.title;
    final visualSize = widget.type==LearningType.hijaiyah ? 150.0 : 132.0;
    return SingleChildScrollView(padding:const EdgeInsets.all(14),child:Column(children:[
      Container(width:double.infinity,padding:const EdgeInsets.all(20),decoration:panel(),child:Column(children:[
        Web3DVisual(
          size: visualSize,
          radius: 32,
          topColor: const Color(0xFFFFFEF7),
          bottomColor: const Color(0xFFD8EEF8),
          child: FittedBox(fit:BoxFit.scaleDown,child:Text(item.visual,style:TextStyle(fontSize:widget.type==LearningType.hijaiyah?100:78))),
        ),
        const SizedBox(height:8),
        Web3DVisual(
          size: 122,
          radius: 28,
          topColor: const Color(0xFFFFFFFF),
          bottomColor: const Color(0xFFE8F4FA),
          child: FittedBox(fit:BoxFit.scaleDown,child:Text(display,style:TextStyle(fontSize:widget.type==LearningType.hijaiyah?70:58,fontWeight:FontWeight.w900,color:const Color(0xFF26324A)))),
        ),
        const SizedBox(height:8),
        Text(item.sound,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w900,color:Color(0xFF2D98C8))),
        const SizedBox(height:12),
        Container(width:double.infinity,padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFF5FBFF),borderRadius:BorderRadius.circular(18)),child:Text(item.hint,textAlign:TextAlign.center,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800,color:Color(0xFF385267)))),
        const SizedBox(height:12),
        ElevatedButton.icon(onPressed:()=>audio.speak(item.title+'. '+item.hint),icon:const Icon(Icons.volume_up_rounded),label:const Text('Dengarkan')),
      ])),
      const SizedBox(height:14),
      Wrap(spacing:8,runSpacing:8,alignment:WrapAlignment.center,children:List.generate(items.length,(i){
        final label=widget.type==LearningType.huruf&&lower?items[i].title.toLowerCase():widget.type==LearningType.angka&&arab?arabic(i+1):items[i].title;
        final active=i==index;
        return InkWell(onTap:()=>setState(()=>index=i),borderRadius:BorderRadius.circular(14),child:Container(width:48,height:48,alignment:Alignment.center,decoration:BoxDecoration(color:active?const Color(0xFFFFC42D):Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:active?const Color(0xFF31536D):const Color(0xFFD8E2EA),width:active?3:1.5)),child:Text(label,style:TextStyle(fontSize:widget.type==LearningType.hijaiyah?27:18,fontWeight:FontWeight.w900,color:const Color(0xFF26324A)))));
      })),
    ]));
  }

  String arabic(int n)=>const ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠'][n-1];

  Widget quiz()=>SingleChildScrollView(padding:const EdgeInsets.all(14),child:Column(children:[
    Text('Pertanyaan '+((qPos%items.length)+1).toString(),style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900,color:Color(0xFF2D98C8))),
    const SizedBox(height:10),
    Container(width:double.infinity,padding:const EdgeInsets.all(20),decoration:panel(),child:Column(children:[
      const Text('Pilih jawaban yang benar!',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:Color(0xFF26324A))),
      const SizedBox(height:16),
      Web3DVisual(
        size: 150,
        radius: 30,
        topColor: const Color(0xFFFFFEF7),
        bottomColor: const Color(0xFFD8EEF8),
        child: FittedBox(fit:BoxFit.scaleDown,child:Text(question.visual,style:TextStyle(fontSize:widget.type==LearningType.hijaiyah?90:78))),
      ),
      const SizedBox(height:10),
      Text('Mana '+question.title+'?',style:const TextStyle(fontSize:26,fontWeight:FontWeight.w900,color:Color(0xFF26324A))),
      const SizedBox(height:14),
      ...options.map((x)=>Padding(padding:const EdgeInsets.only(bottom:10),child:SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>choose(x),style:ElevatedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:16)),child:Text(x.title,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)))))),
      Text('⭐ Skor: '+score.toString(),style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),
    ])),
  ]));

  BoxDecoration panel()=>BoxDecoration(color:Colors.white.withValues(alpha:.95),borderRadius:BorderRadius.circular(28),border:Border.all(color:Colors.white,width:3),boxShadow:const [BoxShadow(color:Color(0x260D405C),blurRadius:14,offset:Offset(0,6))]);
}

class Item {
  final String title,visual,sound,hint;
  const Item(this.title,this.visual,this.sound,this.hint);
}
