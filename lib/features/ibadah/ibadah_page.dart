import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class IbadahPage extends StatefulWidget {
  const IbadahPage({super.key});
  @override State<IbadahPage> createState() => _IbadahPageState();
}

class _IbadahPageState extends State<IbadahPage> with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  late final TabController tabs;
  final doa = const <(String,String,String,String)>[
    ('Sebelum Makan','🤲','Bismillah','بِسْمِ اللّٰهِ'),
    ('Sesudah Makan','😊','Alhamdulillah','اَلْحَمْدُ لِلّٰهِ'),
    ('Sebelum Tidur','😴','Bismika Allahumma ahya wa bismika amut','بِاسْمِكَ اللّٰهُمَّ أَحْيَا وَبِاسْمِكَ أَمُوتُ'),
    ('Bangun Tidur','🌅','Alhamdulillahil ladzi ahyana','اَلْحَمْدُ لِلّٰهِ الَّذِي أَحْيَانَا'),
    ('Masuk Kamar Mandi','🚪','Allahumma inni a udzubika minal khubutsi wal khaba its','اَللّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ'),
  ];
  final wudhu = const <(String,String,String,String)>[
    ('Niat','🤲','Nawaitul wudhu a liraf il hadatsil asghari fardhan lillahi ta ala','نَوَيْتُ الْوُضُوءَ لِرَفْعِ الْحَدَثِ الْأَصْغَرِ فَرْضًا لِلّٰهِ تَعَالَى'),
    ('Cuci Tangan','🧼','Cuci kedua tangan sampai bersih.',''),
    ('Berkumur','💧','Berkumur dengan lembut.',''),
    ('Cuci Wajah','🙂','Basuh seluruh wajah.',''),
    ('Cuci Tangan','🙌','Basuh tangan sampai siku.',''),
    ('Usap Kepala','🧑','Usap sebagian kepala.',''),
    ('Cuci Kaki','🦶','Basuh kedua kaki sampai mata kaki.',''),
  ];
  final sholat = const <(String,String,String,String)>[
    ('Berdiri','🧍','Allahu Akbar','اللّٰهُ أَكْبَرُ'),
    ('Rukuk','🙇','Subhana rabbiyal azhim','سُبْحَانَ رَبِّيَ الْعَظِيمِ'),
    ('I tidal','🧍','Sami allahu liman hamidah','سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ'),
    ('Sujud','🙏','Subhana rabbiyal a la','سُبْحَانَ رَبِّيَ الْأَعْلَى'),
    ('Duduk','🧎','Rabbighfirli warhamni','رَبِّ اغْفِرْ لِي وَارْحَمْنِي'),
    ('Salam','🙂','Assalamu alaikum warahmatullah','السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ'),
  ];

  @override void initState(){super.initState();tabs=TabController(length:3,vsync:this);}
  @override void dispose(){tabs.dispose();super.dispose();}

  @override Widget build(BuildContext context)=>Scaffold(
    body:KidBackground(child:SafeArea(child:Column(children:[
      Padding(padding:const EdgeInsets.all(12),child:Row(children:[
        Material(color:const Color(0xFFFFC42D),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:()=>Navigator.of(context).maybePop(),child:const SizedBox(width:56,height:56,child:Icon(Icons.arrow_back_rounded,color:Colors.white,size:31)))),
        const Expanded(child:Column(children:[
          Text('Belajar Ibadah',style:TextStyle(fontSize:29,fontWeight:FontWeight.w900,color:Color(0xFFFFD32F),shadows:[Shadow(color:Color(0xFF17417B),blurRadius:3,offset:Offset(2,3))])),
          Text('Doa, Wudhu & Sholat',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w800)),
        ])),
        Material(color:const Color(0xFF29C63E),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:()=>audio.speak('Belajar ibadah'),child:const SizedBox(width:56,height:56,child:Icon(Icons.volume_up_rounded,color:Colors.white,size:31)))),
      ])),
      Container(margin:const EdgeInsets.symmetric(horizontal:12),decoration:BoxDecoration(color:Colors.white.withValues(alpha:.92),borderRadius:BorderRadius.circular(20)),child:TabBar(controller:tabs,indicator:BoxDecoration(color:const Color(0xFF2D98C8),borderRadius:BorderRadius.circular(18)),indicatorSize:TabBarIndicatorSize.tab,dividerColor:Colors.transparent,labelColor:Colors.white,unselectedLabelColor:const Color(0xFF52677A),labelStyle:const TextStyle(fontWeight:FontWeight.w900,fontSize:13),tabs:const [Tab(text:'DOA'),Tab(text:'WUDHU'),Tab(text:'SHOLAT')])),
      Expanded(child:TabBarView(controller:tabs,children:[_list(doa),_list(wudhu),_list(sholat)])),
    ]))),
  );

  Widget _list(List<(String,String,String,String)> data)=>ListView.separated(
    padding:const EdgeInsets.all(14),itemCount:data.length,separatorBuilder:(_,__)=>const SizedBox(height:10),
    itemBuilder:(context,i){final x=data[i];return Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white.withValues(alpha:.95),borderRadius:BorderRadius.circular(24),boxShadow:const [BoxShadow(color:Color(0x220D405C),blurRadius:8,offset:Offset(0,4))]),child:Row(children:[
      Text(x.$2,style:const TextStyle(fontSize:54)),const SizedBox(width:14),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(x.$1,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:Color(0xFF26324A))),
        const SizedBox(height:5),Text(x.$3,style:const TextStyle(fontSize:15,fontWeight:FontWeight.w700,color:Color(0xFF52677A))),if(x.$4.isNotEmpty) Padding(padding:const EdgeInsets.only(top:5),child:Text(x.$4,textDirection:TextDirection.rtl,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900,color:Color(0xFF173E70)))),
      ])),
      IconButton(onPressed:()=>audio.speak(x.$3),icon:const Icon(Icons.volume_up_rounded,color:Color(0xFF29A64A),size:30)),
    ]));},
  );
}
