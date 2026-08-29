import 'package:flutter/material.dart';

class FunPage extends StatelessWidget {
  final String title;
  final String emoji;
  final Widget child;

  const FunPage({
    super.key,
    required this.title,
    required this.emoji,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$emoji $title'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}
