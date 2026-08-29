import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class KuisPage extends StatefulWidget { const KuisPage({super.key}); @override State<KuisPage> createState()=>_KuisPageState(); }
class _Question { final String prompt,answer; final List<(String,String)> options; const _Question(this.prompt,this.answer,this.options); }

class _KuisPageState extends State<KuisPage> {
  final audio=AudioService.instance; final random=Random(); late final ConfettiController confetti;
  int number=1; bool? result; late _Question question;
  final bank=const [
    _Question('Mana gambar ikan?','Ikan',[('🐱','Kucing'),('🐟','Ikan'),('🚗','Mobil')]),
    _Question('Mana gambar apel?','Apel',[('🍎','Apel'),('⚽','Bola'),('🐘','Gajah')]),
    _Question('Mana warna merah?','Merah',[('🔵','Biru'),('🔴','Merah'),('🟢','Hijau')]),
  ];
  @override void initState(){super.initState();confetti=ConfettiController(duration:const Duration(seconds:2));question=bank.first;WidgetsBinding.instance.addPostFrameCallback((_)=>audio.question(question.prompt));}
  Future<void> choose(String value) async { if(result!=null)return; final ok=value==question.answer; setState(()=>result=ok); if(ok){confetti.play();await audio.correct();await Future.delayed(const Duration(milliseconds:1500));if(!mounted)return;setState((){number++;question=bank[random.nextInt(bank.length)];result=null;});audio.question(question.prompt);}else{await audio.wrong();await Future.delayed(const Duration(milliseconds:1500));if(mounted)setState(()=>result=null);}}
  @override void dispose(){confetti.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(body:KidBackground(child:SafeArea(child:Stack(children:[
    Column(children:[
      _header(),
      Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Container(
        padding:const EdgeInsets.fromLTRB(16,12,16,20),
        decoration:BoxDecoration(color:Colors.white.withValues(alpha:.94),borderRadius:BorderRadius.circular(30),border:Border.all(color:Colors.white,width:3)),
        child:Column(children:[
          Container(padding:const EdgeInsets.symmetric(horizontal:22,vertical:7),decoration:BoxDecoration(color:const Color(0xFF56B9E8),borderRadius:BorderRadius.circular(18)),child:Text('Pertanyaan $number',style:const TextStyle(color:Colors.white,fontSize:17,fontWeight:FontWeight.w900))),
          const SizedBox(height:16),
          Text(question.prompt,textAlign:TextAlign.center,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900,color:Color(0xFF17223B))),
          const SizedBox(height:20),
          Row(children:question.options.map((o)=>Expanded(child:Padding(
            padding:const EdgeInsets.symmetric(horizontal:5),
            child:Material(color:Colors.white,borderRadius:BorderRadius.circular(22),elevation:3,child:InkWell(
              onTap:()=>choose(o.$2),borderRadius:BorderRadius.circular(22),
              child:SizedBox(height:132,child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                Text(o.$1,style:const TextStyle(fontSize:62)),
                Text(o.$2,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w900)),
              ])),
            )),
          ))).toList()),
        ]),
      )),
    ]),
    Align(alignment:Alignment.topCenter,child:ConfettiWidget(confettiController:confetti,blastDirectionality:BlastDirectionality.explosive,numberOfParticles:38,gravity:.25)),
    if(result!=null)_feedback(result!),
  ]))));
  Widget _header()=>SizedBox(height:92,child:Stack(alignment:Alignment.center,children:[
    Positioned(left:22,child:Material(color:const Color(0xFFFFC42D),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:()=>Navigator.of(context).maybePop(),child:const SizedBox(width:62,height:62,child:Icon(Icons.arrow_back_rounded,color:Colors.white,size:36))))),
    const Positioned(right:22,child:CircleAvatar(radius:31,backgroundColor:Color(0xFF29C63E),child:Icon(Icons.music_note_rounded,color:Colors.white,size:34))),
    const Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('🏆 Kuis Seru',style:TextStyle(fontSize:35,color:Color(0xFFFFD32F),fontWeight:FontWeight.w900)),Text('Ayo Jawab Pertanyaannya!',style:TextStyle(fontSize:17,color:Colors.white,fontWeight:FontWeight.w900))]),
  ]));
  Widget _feedback(bool ok)=>Positioned.fill(child:Container(color:(ok?const Color(0xFF42C95A):const Color(0xFFFF746C)).withValues(alpha:.96),child:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Text(ok?'🦕':'🐯',style:const TextStyle(fontSize:180)),
    Text(ok?'Hebat!':'Coba lagi ya!',style:const TextStyle(color:Color(0xFFFFF3A8),fontSize:52,fontWeight:FontWeight.w900)),
    Text(ok?'Jawaban kamu benar!':'Tidak apa-apa, coba sekali lagi.',style:const TextStyle(color:Colors.white,fontSize:23,fontWeight:FontWeight.w900)),
  ]))));
}