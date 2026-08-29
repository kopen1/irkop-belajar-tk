import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class MewarnaiPage extends StatefulWidget {
  const MewarnaiPage({super.key});

  @override
  State<MewarnaiPage> createState() =>
      _MewarnaiPageState();
}

class _MewarnaiPageState
    extends State<MewarnaiPage> {
  Color color = Colors.red;
  bool painted = false;

  final colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: KidHeader(
                title: 'Mewarnai 🖍️',
                subtitle:
                    'Pilih warna lalu tekan gambar',
              ),
            ),

            const Text(
              'Contoh: 🐱 Kucing Berwarna',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),

            const Text(
              '🐱',
              style: TextStyle(
                fontSize: 90,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(
                      () => painted = true,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    width: 250,
                    height: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: painted
                          ? color.withValues(alpha: 0.82)
                          : Colors.white.withValues(alpha: 0.94),
                      borderRadius:
                          BorderRadius.circular(
                        100,
                      ),
                      border: Border.all(
                        width: 7,
                        color: Colors.black,
                      ),
                    ),
                    child: const Text(
                      '🐱',
                      style: TextStyle(
                        fontSize: 150,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            color = c;
                            painted = true;
                          },
                        );
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c == color ? const Color(0xFF31536D) : Colors.white,
                            width: c == color ? 5 : 3,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(
                          () => painted = true,
                        );
                      },
                      child: const Text(
                        '🖌 Cat',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(
                          () => painted = false,
                        );
                      },
                      child: const Text(
                        '🧽 Hapus',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
