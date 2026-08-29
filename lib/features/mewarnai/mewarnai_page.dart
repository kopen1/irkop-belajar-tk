import 'package:flutter/material.dart';
import '../../core/widgets/kid_background.dart';
import 'painting_canvas.dart';

class MewarnaiPage extends StatefulWidget { const MewarnaiPage({super.key}); @override State<MewarnaiPage> createState()=>_MewarnaiPageState(); }
class _MewarnaiPageState extends State<MewarnaiPage> {
  Color selected=Colors.red;
  final colors=const [Color(0xFFFF2433),Color(0xFFFF8214),Color(0xFFFFD31B),Color(0xFF2BC53B),Color(0xFF1E8ED9),Color(0xFF6542CF),Color(0xFFE436A7),Color(0xFF20252D)];
  @override Widget build(BuildContext context)=>Scaffold(body:KidBackground(child:SafeArea(child:LayoutBuilder(builder:(context,box){
    final w=box.maxWidth; final s=(w/820).clamp(.72,1.0);
    return Column(children:[
      _header(w,s),
      Expanded(child:Padding(
        padding:EdgeInsets.fromLTRB(w*.04,8,w*.04,14),
        child:Column(children:[
          Expanded(child:Container(
            width:double.infinity,padding:EdgeInsets.all(12*s),
            decoration:BoxDecoration(color:Colors.white.withValues(alpha:.95),borderRadius:BorderRadius.circular(30*s),border:Border.all(color:Colors.white,width:3)),
            child:Stack(children:[
              Positioned.fill(child:CustomPaint(painter:_DinoOutlinePainter())),
              Positioned.fill(child:PaintingCanvas(color:selected)),
            ]),
          )),
          SizedBox(height:12*s),
          Container(
            padding:EdgeInsets.all(12*s),
            decoration:BoxDecoration(color:Colors.white.withValues(alpha:.92),borderRadius:BorderRadius.circular(26*s)),
            child:Row(children:[
              Expanded(child:Wrap(
                spacing:10*s,runSpacing:8*s,
                children:colors.map((c)=>GestureDetector(
                  onTap:()=>setState(()=>selected=c),
                  child:Container(width:36*s,height:36*s,decoration:BoxDecoration(color:c,shape:BoxShape.circle,border:Border.all(color:c==selected?Colors.white:const Color(0x33000000),width:c==selected?4:2))),
                )).toList(),
              )),
              SizedBox(width:10*s),
              Material(color:const Color(0xFFFFC62E),borderRadius:BorderRadius.circular(16*s),child:InkWell(
                onTap:()=>setState((){}),
                child:SizedBox(width:58*s,height:54*s,child:Icon(Icons.brush_rounded,color:Colors.white,size:31*s)),
              )),
            ]),
          ),
        ]),
      )),
    ]);
  }))));
  Widget _header(double w,double s)=>SizedBox(height:w*.14,child:Stack(alignment:Alignment.center,children:[
    Positioned(left:w*.035,child:Material(color:const Color(0xFFFFC42D),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:()=>Navigator.of(context).maybePop(),child:SizedBox(width:w*.105,height:w*.105,child:Icon(Icons.arrow_back_rounded,color:Colors.white,size:w*.06))))),
    Positioned(right:w*.035,child:Material(color:const Color(0xFF29C63E),shape:const CircleBorder(),child:SizedBox(width:w*.105,height:w*.105,child:Icon(Icons.music_note_rounded,color:Colors.white,size:w*.06)))),
    Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      Text('Ayo Mewarnai',style:TextStyle(fontSize:35*s,color:const Color(0xFFFFD32F),fontWeight:FontWeight.w900)),
      Text('Warnai Gambar Sesukamu!',style:TextStyle(fontSize:17*s,color:Colors.white,fontWeight:FontWeight.w900)),
    ]),
  ]));
}
class _DinoOutlinePainter extends CustomPainter {
 @override void paint(Canvas canvas,Size size){final p=Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=5..strokeCap=StrokeCap.round;final body=RRect.fromRectAndRadius(Rect.fromLTWH(size.width*.23,size.height*.20,size.width*.52,size.height*.62),Radius.circular(size.width*.20));canvas.drawRRect(body,p);canvas.drawCircle(Offset(size.width*.54,size.height*.39),size.width*.17,p);}
 @override bool shouldRepaint(covariant _DinoOutlinePainter old)=>false;
}