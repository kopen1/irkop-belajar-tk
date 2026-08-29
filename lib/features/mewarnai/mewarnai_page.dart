import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class MewarnaiPage extends StatefulWidget {
  const MewarnaiPage({super.key});

  @override
  State<MewarnaiPage> createState() => _MewarnaiPageState();
}

class _MewarnaiPageState extends State<MewarnaiPage> {
  int _drawing = 0;
  int _selectedColor = 0;
  bool _erase = false;

  final colors = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  final drawings = [
    '🐱 Kucing',
    '🌸 Bunga',
    '🏠 Rumah',
    '🐟 Ikan',
    '🚗 Mobil',
  ];

  final Map<int, Color?> painted = {};

  void _paint(int part) {
    setState(() {
      painted[part] = _erase ? Colors.white : colors[_selectedColor];
    });
    AudioService.instance.speak(
      _erase ? 'Menghapus warna' : 'Mewarnai',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: KidHeader(
                title: 'Mewarnai',
                subtitle: 'Lihat contoh lalu warnai gambarnya',
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: List.generate(drawings.length, (i) {
                        return ChoiceChip(
                          label: Text(drawings[i]),
                          selected: _drawing == i,
                          onSelected: (_) {
                            setState(() {
                              _drawing = i;
                              painted.clear();
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _exampleCard(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _paintCard(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(colors.length, (i) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedColor = i;
                              _erase = false;
                            });
                          },
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == i && !_erase
                                    ? Colors.black
                                    : Colors.white,
                                width: 4,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            setState(() => _erase = false);
                          },
                          icon: const Icon(Icons.brush),
                          label: const Text('Cat'),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() => _erase = true);
                          },
                          icon: const Icon(Icons.cleaning_services),
                          label: const Text('Hapus'),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(painted.clear);
                          },
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Bersihkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exampleCard() {
    return Container(
      height: 330,
      decoration: _card(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Contoh Jadi',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                ['🐱', '🌸', '🏠', '🐟', '🚗'][_drawing],
                style: const TextStyle(fontSize: 120),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paintCard() {
    return Container(
      height: 330,
      decoration: _card(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Warnai',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              children: List.generate(6, (part) {
                return GestureDetector(
                  onTap: () => _paint(part),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: painted[part] ?? Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.black54,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ['●', '▲', '■', '★', '◆', '♥'][part],
                        style: const TextStyle(
                          fontSize: 45,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}
