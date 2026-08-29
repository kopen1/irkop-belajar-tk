import 'package:flutter/material.dart';

import '../../shared/widgets/fun_page.dart';
import 'connect_dots_canvas.dart';

class TitikGarisPage extends StatelessWidget {
  const TitikGarisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Tarik Titik ke Titik',
      emoji: '✏️',
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: ConnectDotsCanvas(),
      ),
    );
  }
}
