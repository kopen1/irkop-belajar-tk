import 'package:flutter/material.dart';

class PaintingCanvas extends StatefulWidget {
  final Color color;
  final int clearSignal;
  final int fillSignal;
  final Color fillColor;
  const PaintingCanvas({
    super.key,
    required this.color,
    this.clearSignal = 0,
    this.fillSignal = 0,
    this.fillColor = Colors.transparent,
  });
  @override State<PaintingCanvas> createState() => _PaintingCanvasState();
}

class _PaintingCanvasState extends State<PaintingCanvas> {
  final lines = <_Stroke>[];
  List<Offset>? current;
  Color background = Colors.transparent;

  @override void didUpdateWidget(covariant PaintingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.clearSignal != oldWidget.clearSignal) {
      lines.clear(); current=null; background=Colors.transparent;
    }
    if(widget.fillSignal != oldWidget.fillSignal) background=widget.fillColor;
  }

  @override Widget build(BuildContext context) => GestureDetector(
    onPanStart:(d){
      final box=context.findRenderObject() as RenderBox;
      current=[box.globalToLocal(d.globalPosition)];
      setState(()=>lines.add(_Stroke(widget.color,current!)));
    },
    onPanUpdate:(d){
      final box=context.findRenderObject() as RenderBox;
      setState(()=>current?.add(box.globalToLocal(d.globalPosition)));
    },
    onPanEnd:(_)=>current=null,
    child:CustomPaint(painter:_Painter(lines,background),child:const SizedBox.expand()),
  );
}

class _Stroke {
  final Color color; final List<Offset> points;
  _Stroke(this.color,this.points);
}

class _Painter extends CustomPainter {
  final List<_Stroke> lines; final Color background;
  _Painter(this.lines,this.background);
  @override void paint(Canvas canvas,Size size){
    if(background != Colors.transparent) canvas.drawRect(Offset.zero&size,Paint()..color=background.withValues(alpha:.55));
    for(final line in lines){
      final p=Paint()..color=line.color.withValues(alpha:.82)..strokeWidth=18..strokeCap=StrokeCap.round;
      if(line.points.length==1){canvas.drawCircle(line.points.first,p.strokeWidth/2,p);continue;}
      for(var i=0;i<line.points.length-1;i++){canvas.drawLine(line.points[i],line.points[i+1],p);}
    }
  }
  @override bool shouldRepaint(covariant _Painter old)=>true;
}
