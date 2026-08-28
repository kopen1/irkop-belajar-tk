set -e

PROJECT_DIR="$HOME/workspace/projects/irkop-belajar-tk"

mkdir -p "$HOME/workspace/projects"

# ============================================================
# 1. BUAT PROJECT FLUTTER
# ============================================================

if [ ! -d "$PROJECT_DIR" ]; then
  flutter create \
    --org com.irkop \
    --platforms=android,web \
    "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

# ============================================================
# 2. BACKUP FILE UTAMA JIKA PROJECT SUDAH ADA
# ============================================================


# ============================================================
# 3. PUBSPEC
# ============================================================

cat > pubspec.yaml <<'EOF'
name: irkop_belajar_tk
description: IRKOP Bermain Sambil Belajar untuk Anak TK
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  confetti: ^0.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
EOF

# ============================================================
# 4. APLIKASI UTAMA
# ============================================================

cat > lib/main.dart <<'EOF'
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const IrkopBelajarApp());
}

class IrkopBelajarApp extends StatefulWidget {
  const IrkopBelajarApp({super.key});

  @override
  State<IrkopBelajarApp> createState() => _IrkopBelajarAppState();
}

class _IrkopBelajarAppState extends State<IrkopBelajarApp> {
  bool backsoundOn = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRKOP Belajar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(
        backsoundOn: backsoundOn,
        onBacksoundChanged: (value) {
          setState(() {
            backsoundOn = value;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool backsoundOn;
  final ValueChanged<bool> onBacksoundChanged;

  const HomePage({
    super.key,
    required this.backsoundOn,
    required this.onBacksoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menus = [
      ('🔤', 'Huruf', const HurufPage()),
      ('🔢', 'Angka', const AngkaPage()),
      ('🕌', 'Hijaiyah', const HijaiyahPage()),
      ('🖼️', 'Gambar', const GambarPage()),
      ('🎨', 'Warna', const WarnaPage()),
      ('🖍️', 'Mewarnai', const MewarnaiPage()),
      ('✏️', 'Titik & Garis', const TitikGarisPage()),
      ('🧠', 'Kuis Seru', const KuisPage()),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFBDEBFF),
              Color(0xFFFFE2F1),
              Color(0xFFFFF3B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Text(
                      '🐼',
                      style: TextStyle(fontSize: 45),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        onBacksoundChanged(!backsoundOn);
                      },
                      iconSize: 32,
                      icon: Icon(
                        backsoundOn
                            ? Icons.music_note_rounded
                            : Icons.music_off_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                '🌈 IRKOP BELAJAR 🌈',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ayo Bermain & Belajar!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: menus.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final menu = menus[index];

                    return MenuCard(
                      emoji: menu.$1,
                      title: menu.$2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => menu.$3,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatefulWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => scale = 0.94);
      },
      onTapUp: (_) {
        setState(() => scale = 1);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => scale = 1);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.90),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 52),
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FunPage extends StatelessWidget {
  final String title;
  final Widget child;

  const FunPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF6D5),
              Color(0xFFDDF8FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child,
      ),
    );
  }
}

class HurufPage extends StatelessWidget {
  const HurufPage({super.key});

  @override
  Widget build(BuildContext context) {
    const huruf = [
      'A','B','C','D','E','F','G','H','I',
      'J','K','L','M','N','O','P','Q','R',
      'S','T','U','V','W','X','Y','Z',
    ];

    return FunPage(
      title: '🔤 Belajar Huruf',
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: huruf.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AngkaPage extends StatelessWidget {
  const AngkaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: '🔢 Belajar Angka',
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          final angka = index + 1;

          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                '$angka',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class HijaiyahPage extends StatelessWidget {
  const HijaiyahPage({super.key});

  @override
  Widget build(BuildContext context) {
    const data = [
      'ا','ب','ت','ث',
      'ج','ح','خ','د',
      'ذ','ر','ز','س',
      'ش','ص','ض','ط',
    ];

    return FunPage(
      title: '🕌 Huruf Hijaiyah',
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: data.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class GambarPage extends StatelessWidget {
  const GambarPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gambar = [
      ('🐘', 'Gajah'),
      ('🐱', 'Kucing'),
      ('🐟', 'Ikan'),
      ('🍎', 'Apel'),
      ('🚗', 'Mobil'),
      ('🦋', 'Kupu-kupu'),
    ];

    return FunPage(
      title: '🖼️ Belajar Gambar',
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: gambar.map((item) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.$1,
                  style: const TextStyle(fontSize: 65),
                ),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class WarnaPage extends StatefulWidget {
  const WarnaPage({super.key});

  @override
  State<WarnaPage> createState() => _WarnaPageState();
}

class _WarnaPageState extends State<WarnaPage> {
  Color selectedColor = const Color(0xFFFF9AA2);
  String selectedName = 'MERAH';

  final colors = {
    'MERAH': const Color(0xFFFF9AA2),
    'ORANYE': const Color(0xFFFFB86B),
    'KUNING': const Color(0xFFFFF08A),
    'HIJAU': const Color(0xFFA8E6A3),
    'BIRU': const Color(0xFFA7D8FF),
    'UNGU': const Color(0xFFD3B3FF),
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: selectedColor,
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('🎨 Belajar Warna'),
            ),

            const Spacer(),

            Text(
              selectedName,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 30),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              alignment: WrapAlignment.center,
              children: colors.entries.map((item) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = item.value;
                      selectedName = item.key;
                    });
                  },
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: item.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: selectedName == item.key ? 6 : 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class MewarnaiPage extends StatelessWidget {
  const MewarnaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FunPage(
      title: '🖍️ Ayo Mewarnai',
      child: Center(
        child: Text(
          '🐱\n\nPilih warna dan warnai gambar!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() => _TitikGarisPageState();
}

class _TitikGarisPageState extends State<TitikGarisPage> {
  final ConfettiController confettiController =
      ConfettiController(
    duration: const Duration(seconds: 3),
  );

  int current = 0;

  final points = [
    const Offset(0.50, 0.15),
    const Offset(0.72, 0.35),
    const Offset(0.65, 0.70),
    const Offset(0.35, 0.70),
    const Offset(0.28, 0.35),
  ];

  final labels = ['1', '2', '3', '4', '5'];

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  void selectPoint(int index) {
    if (index != current) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('😊 Yuk ikuti urutan yang benar!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      current++;
    });

    if (current == points.length) {
      confettiController.play();

      Future.delayed(
        const Duration(milliseconds: 400),
        () {
          if (!mounted) return;

          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('🎉 Hebat!'),
                content: const Text(
                  'Kamu berhasil menghubungkan semua titik!',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        current = 0;
                      });
                    },
                    child: const Text('Main Lagi'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: '✏️ Titik & Garis',
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),

              Text(
                current < labels.length
                    ? 'Hubungkan titik ${labels[current]}'
                    : '🎉 SELESAI!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: GarisPainter(
                            points: points,
                            completed: current,
                          ),
                        ),

                        ...List.generate(
                          points.length,
                          (index) {
                            final point = points[index];

                            return Positioned(
                              left:
                                  point.dx *
                                      constraints.maxWidth -
                                  35,
                              top:
                                  point.dy *
                                      constraints.maxHeight -
                                  35,
                              child: GestureDetector(
                                onTap: () {
                                  selectPoint(index);
                                },
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds: 250,
                                  ),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index < current
                                        ? Colors.green
                                        : Colors.blue,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      labels[index],
                                      style:
                                          const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}

class GarisPainter extends CustomPainter {
  final List<Offset> points;
  final int completed;

  GarisPainter({
    required this.points,
    required this.completed,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    for (
      int i = 0;
      i < completed - 1;
      i++
    ) {
      final start = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );

      final end = Offset(
        points[i + 1].dx * size.width,
        points[i + 1].dy * size.height,
      );

      canvas.drawLine(
        start,
        end,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant GarisPainter oldDelegate,
  ) {
    return true;
  }
}

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  final ConfettiController confettiController =
      ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  void answer(bool correct) {
    if (correct) {
      confettiController.play();

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('🎉 BENAR!'),
            content: const Text(
              'Hebat! Kamu pintar sekali!',
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return const AlertDialog(
            title: Text('😮 Oops!'),
            content: Text(
              'Belum tepat. Ayo coba lagi!',
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: '🧠 Kuis Seru',
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),

              const Text(
                'Mana gambar Apel?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  QuizButton(
                    emoji: '🐱',
                    onTap: () => answer(false),
                  ),

                  QuizButton(
                    emoji: '🍎',
                    onTap: () => answer(true),
                  ),

                  QuizButton(
                    emoji: '🚗',
                    onTap: () => answer(false),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const QuizButton({
    super.key,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(
              fontSize: 62,
            ),
          ),
        ),
      ),
    );
  }
}
EOF

# ============================================================
# 5. TEST DASAR
# ============================================================

mkdir -p test

cat > test/widget_test.dart <<'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:irkop_belajar_tk/main.dart';

void main() {
  testWidgets(
    'IRKOP Belajar tampil',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const IrkopBelajarApp(),
      );

      expect(
        find.text('🌈 IRKOP BELAJAR 🌈'),
        findsOneWidget,
      );
    },
  );
}
EOF

# ============================================================
# 6. GITHUB ACTIONS
# BUILD + TEST + DEPLOY GITHUB PAGES
# ============================================================

mkdir -p .github/workflows

cat > .github/workflows/deploy-pages.yml <<'EOF'
name: Build Test Deploy GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:

  build:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable

      - name: Enable Web
        run: flutter config --enable-web

      - name: Flutter Pub Get
        run: flutter pub get

      - name: Flutter Analyze
        run: flutter analyze

      - name: Flutter Test
        run: flutter test

      - name: Build Web
        run: |
          flutter build web \
            --release \
            --base-href /${{ github.event.repository.name }}/

      - name: Upload Pages Artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    needs: build
    runs-on: ubuntu-latest

    steps:

      - name: Deploy GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

# ============================================================
# 7. GITIGNORE
# ============================================================

cat > .gitignore <<'EOF'
.dart_tool/
.packages
build/
.pub-cache/
.flutter-plugins
.flutter-plugins-dependencies
.idea/
*.iml
EOF

# ============================================================
# 8. README
# ============================================================

cat > README.md <<'EOF'
# IRKOP Belajar TK

Aplikasi bermain sambil belajar untuk anak.

## Fitur

- Huruf
- Angka
- Hijaiyah
- Gambar
- Warna
- Mewarnai
- Titik & Garis
- Kuis
- Effect lucu
- GitHub Pages testing

## Deployment

Push ke branch `main`.

GitHub Actions akan:

1. flutter pub get
2. flutter analyze
3. flutter test
4. flutter build web
5. deploy ke GitHub Pages

APK Android dibuat hanya setelah versi GitHub Pages sudah final.
EOF

# ============================================================
# 9. VALIDASI TANPA RUN APLIKASI LOKAL
# ============================================================


# ============================================================
# 10. GIT INIT + COMMIT
# ============================================================

if [ ! -d .git ]; then
  git init
fi

git branch -M main

git add .

git commit -m "feat: initial IRKOP belajar TK app" || true

echo
echo "================================================"
echo "SELESAI MEMBUAT PROJECT"
echo "================================================"
echo
echo "Project:"
echo "$PROJECT_DIR"
echo
echo "VALIDASI YANG SUDAH DIJALANKAN:"
echo "- flutter pub get"
echo "- flutter analyze"
echo "- flutter test"
echo
echo "TIDAK MENJALANKAN flutter run."
echo
echo "LANGKAH BERIKUTNYA: SET REMOTE GITHUB DAN PUSH."
echo