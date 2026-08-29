import 'package:flutter/material.dart';

import '../../shared/widgets/fun_page.dart';
import 'painting_canvas.dart';

class MewarnaiPage extends StatefulWidget {
  const MewarnaiPage({super.key});

  @override
  State<MewarnaiPage> createState() => _MewarnaiPageState();
}

class _MewarnaiPageState extends State<MewarnaiPage> {
  Color selectedColor = Colors.red;

  final colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Ayo Mewarnai',
      emoji: '🖍️',
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PaintingCanvas(
                color: selectedColor,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: colors.length,
              itemBuilder: (_, index) {
                final color = colors[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: selectedColor == color ? 5 : 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
