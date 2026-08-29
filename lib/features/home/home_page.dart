import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import '../learning/learning_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../kuis/kuis_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 12),

              const Text(
                '🎓 IRKOP Belajar TK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF31536D),
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Ayo bermain sambil belajar! 🌈',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF55758C),
                ),
              ),

              const SizedBox(height: 20),

              _card(
                context,
                '🔤',
                'Dunia Huruf',
                'Belajar A sampai Z',
                const LearningPage(type: LearningType.huruf),
              ),

              _card(
                context,
                '🔢',
                'Dunia Angka',
                'Belajar angka sambil bermain',
                const LearningPage(type: LearningType.angka),
              ),

              _card(
                context,
                '🕌',
                'Hijaiyah',
                'Kenali huruf Hijaiyah',
                const LearningPage(type: LearningType.hijaiyah),
              ),

              _card(
                context,
                '🐱',
                'Dunia Gambar',
                'Hewan, buah dan benda',
                const LearningPage(type: LearningType.gambar),
              ),

              _card(
                context,
                '🎨',
                'Dunia Warna',
                'Klik warna, background berubah!',
                const LearningPage(type: LearningType.warna),
              ),

              _card(
                context,
                '🖍️',
                'Mewarnai',
                'Pilih warna dan gambar',
                const MewarnaiPage(),
              ),

              _card(
                context,
                '🔗',
                'Titik & Garis',
                'Tarik garis mengikuti urutan',
                const TitikGarisPage(),
              ),

              _card(
                context,
                '🧠',
                'Kuis Seru',
                'Pertanyaan tanpa batas',
                const KuisPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    String emoji,
    String title,
    String subtitle,
    Widget page,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        elevation: 5,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _go(context, page),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF31536D),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF668398),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF5EA8F5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
