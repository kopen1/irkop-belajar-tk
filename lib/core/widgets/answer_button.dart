import 'package:flutter/material.dart';
import '../theme/kids_theme.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const AnswerButton({super.key, required this.text, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x180D405C), blurRadius: 8, offset: Offset(0, 4))]),
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12), child: Center(child: Text(''))),
        ),
      ),
    );
  }
}
