import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../shared/widgets/fun_page.dart';

class WarnaPage extends StatefulWidget {
  const WarnaPage({super.key});

  @override
  State<WarnaPage> createState() => _WarnaPageState();
}

class _WarnaPageState extends State<WarnaPage> {
  Color background = Colors.white;

  final colors = <String, Color>{
    'Merah': Colors.red,
    'Biru': Colors.blue,
    'Hijau': Colors.green,
    'Kuning': Colors.yellow,
    'Oranye': Colors.orange,
    'Ungu': Colors.purple,
    'Pink': Colors.pink,
    'Coklat': Colors.brown,
    'Hitam': Colors.black,
    'Putih': Colors.white,
  };

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Belajar Warna',
      emoji: '🎨',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: background,
        child: GridView(
          padding: const EdgeInsets.all(18),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: colors.entries.map((entry) {
            return InkWell(
              onTap: () {
                AudioService.speak(entry.key);

                setState(() {
                  background = entry.value.withOpacity(0.35);
                });
              },
              borderRadius: BorderRadius.circular(28),
              child: Container(
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: entry.value == Colors.white ||
                              entry.value == Colors.yellow
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
