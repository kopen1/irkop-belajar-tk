import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../angka/angka_page.dart';
import '../gambar/gambar_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../huruf/huruf_page.dart';
import '../kuis/kuis_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../warna/warna_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AudioService.instance.init();
      AudioService.instance.speak(
        'Halo teman-teman! Selamat datang di IRKOP Belajar TK!',
      );
    });
  }

  void open(Widget page, String sound) {
    AudioService.instance.speak(sound);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = [
      _Menu(
        '🔤',
        'Dunia Huruf',
        const Color(0xFF5BA9F7),
        const HurufPage(),
      ),
      _Menu(
        '🔢',
        'Dunia Angka',
        const Color(0xFFFFA24C),
        const AngkaPage(),
      ),
      _Menu(
        '🕌',
        'Hijaiyah',
        const Color(0xFF9B7BEA),
        const HijaiyahPage(),
      ),
      _Menu(
        '🐱',
        'Dunia Gambar',
        const Color(0xFF63C174),
        const GambarPage(),
      ),
      _Menu(
        '🎨',
        'Dunia Warna',
        const Color(0xFFFF7FA3),
        const WarnaPage(),
      ),
      _Menu(
        '🖍️',
        'Mewarnai',
        const Color(0xFFEF8F5A),
        const MewarnaiPage(),
      ),
      _Menu(
        '🔗',
        'Titik & Garis',
        const Color(0xFF48BFC0),
        const TitikGarisPage(),
      ),
      _Menu(
        '🧠',
        'Kuis Seru',
        const Color(0xFFFFC94D),
        const KuisPage(),
      ),
    ];

    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              'IRKOP',
              style: TextStyle(
                fontSize: 39,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2E4B63),
              ),
            ),

            const Text(
              'Bermain Sambil Belajar',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Color(0xFF486B82),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '🐼',
              style: TextStyle(fontSize: 75),
            ),

            const Text(
              'Ayo pilih dunia bermainmu!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  20,
                ),
                itemCount: menus.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.12,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (_, index) {
                  final menu = menus[index];

                  return InkWell(
                    onTap: () => open(
                      menu.page,
                      menu.title,
                    ),
                    borderRadius:
                        BorderRadius.circular(28),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: menu.color,
                        borderRadius:
                            BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            menu.icon,
                            style: const TextStyle(
                              fontSize: 54,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            menu.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Menu {
  final String icon;
  final String title;
  final Color color;
  final Widget page;

  const _Menu(
    this.icon,
    this.title,
    this.color,
    this.page,
  );
}
