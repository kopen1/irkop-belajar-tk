import 'package:flutter/material.dart';
import '../../core/theme/kids_theme.dart';
import '../../services/background_music.dart';
import '../../core/widgets/kid_background.dart';
import '../angka/angka_page.dart';
import '../gambar/gambar_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../huruf/huruf_page.dart';
import '../kuis/kuis_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../warna/warna_page.dart';
import '../pengaturan/pengaturan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _go(BuildContext c, Widget p) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => p));
  @override Widget build(BuildContext context) {
    const e = [_HomeEntry('🔤','Dunia Huruf',KidsTheme.pink),_HomeEntry('🔢','Dunia Angka',KidsTheme.primary),_HomeEntry('🕌','Dunia Hijaiyah',KidsTheme.green),_HomeEntry('🐱','Dunia Gambar',KidsTheme.orange),_HomeEntry('🎨','Dunia Warna',KidsTheme.purple),_HomeEntry('🖍️','Mewarnai',KidsTheme.pink),_HomeEntry('🔗','Titik & Garis',KidsTheme.yellow),_HomeEntry('🧠','Kuis Seru',KidsTheme.purple)];
    const p = [HurufPage(),AngkaPage(),HijaiyahPage(),GambarPage(),WarnaPage(),MewarnaiPage(),TitikGarisPage(),KuisPage()];
    return Scaffold(body: KidBackground(child: SafeArea(child: LayoutBuilder(builder: (context,c) { final compact=c.maxWidth<430; final cols=c.maxWidth>=700?4:2; return SingleChildScrollView(padding: EdgeInsets.all(compact?16:24), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth:900), child: Column(children:[_Hero(compact:compact,onSettings:()=>_go(context,const PengaturanPage())),const SizedBox(height:18),GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:e.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:cols,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:cols==2?1.05:1),itemBuilder:(_,i)=>_HomeCard(entry:e[i],compact:compact,onTap:()=>_go(context,p[i])))])))); }))));
  }
}
class _Hero extends StatelessWidget { final bool compact; final VoidCallback onSettings; const _Hero({required this.compact,required this.onSettings}); @override Widget build(BuildContext context) { final m=BackgroundMusic.instance; return Container(padding:const EdgeInsets.fromLTRB(20,14,20,20),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(28),border:Border.all(color:KidsTheme.border),boxShadow:const[BoxShadow(color:Color(0x180D405C),blurRadius:14,offset:Offset(0,6))]),child:Column(children:[Row(children:[const Spacer(),ValueListenableBuilder<bool>(valueListenable:m.enabled,builder:(_,on,__)=>_SoundButton(on:on,onTap:(){m.toggle();if(m.enabled.value)m.start();})),const SizedBox(width:8),Material(color:KidsTheme.primary,shape:const CircleBorder(),elevation:2,child:InkWell(customBorder:const CircleBorder(),onTap:onSettings,child:const SizedBox(width:54,height:54,child:Icon(Icons.settings_rounded,color:Colors.white,size:29))))]),Text('Halo, Teman Pintar! 👋',textAlign:TextAlign.center,style:TextStyle(fontSize:compact?25:31,fontWeight:FontWeight.w900,color:KidsTheme.ink)),const SizedBox(height:3),Text('IRKOP Belajar TK',style:TextStyle(fontSize:compact?30:40,fontWeight:FontWeight.w900,color:KidsTheme.primary)),const SizedBox(height:4),Text('Yuk belajar sambil bermain! 🌈',style:TextStyle(fontSize:compact?14:17,fontWeight:FontWeight.w700,color:KidsTheme.muted)),const SizedBox(height:4),Text('🐼',style:TextStyle(fontSize:compact?54:66))])); } }
class _SoundButton extends StatelessWidget { final bool on; final VoidCallback onTap; const _SoundButton({required this.on,required this.onTap}); @override Widget build(BuildContext c)=>Material(color:on?KidsTheme.green:KidsTheme.muted,shape:const CircleBorder(),elevation:2,child:InkWell(customBorder:const CircleBorder(),onTap:onTap,child:const SizedBox(width:54,height:54,child:Icon(Icons.volume_up_rounded,color:Colors.white,size:29)))); }
class _HomeEntry { final String emoji,title; final Color color; const _HomeEntry(this.emoji,this.title,this.color); }
class _HomeCard extends StatelessWidget { final _HomeEntry entry; final bool compact; final VoidCallback onTap; const _HomeCard({required this.entry,required this.compact,required this.onTap}); @override Widget build(BuildContext c)=>Material(color:Colors.white,borderRadius:BorderRadius.circular(24),elevation:2,child:InkWell(borderRadius:BorderRadius.circular(24),onTap:onTap,child:Padding(padding:EdgeInsets.all(compact?12:16),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Container(width:compact?68:78,height:compact?68:78,decoration:BoxDecoration(color:entry.color.withValues(alpha:.15),shape:BoxShape.circle),child:Center(child:Text(entry.emoji,style:TextStyle(fontSize:compact?39:46)))),const SizedBox(height:10),Text(entry.title,textAlign:TextAlign.center,maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(fontSize:compact?17:19,fontWeight:FontWeight.w900,color:KidsTheme.ink)),const SizedBox(height:5),Icon(Icons.arrow_forward_rounded,color:entry.color,size:22)])))); }
}
