import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/mini_quiz_panel.dart';

class GambarPage extends StatefulWidget {
  const GambarPage({super.key});

  @override
  State<GambarPage> createState() => _GambarPageState();
}

class _GambarPageState extends State<GambarPage> {
  final audio = AudioService.instance;
  int category = 0;
  int page = 0;
  int _tab = 0;

  static const _categories = [
    ('🐾', 'Hewan'),
    ('🍊', 'Buah'),
    ('🚙', 'Kendaraan'),
    ('🎒', 'Benda'),
  ];

  static const _items = [
    [('🐱', 'Kucing'), ('🦁', 'Singa'), ('🐘', 'Gajah'), ('🐰', 'Kelinci'), ('🦒', 'Jerapah'), ('🦓', 'Zebra'), ('🐔', 'Ayam'), ('🦆', 'Bebek'), ('🐦', 'Burung'), ('🐟', 'Ikan'), ('🐮', 'Sapi'), ('🐼', 'Panda')],
    [('🍎', 'Apel'), ('🍌', 'Pisang'), ('🍊', 'Jeruk'), ('🍇', 'Anggur'), ('🍉', 'Semangka'), ('🍓', 'Stroberi'), ('🍍', 'Nanas'), ('🥭', 'Mangga'), ('🍐', 'Pir'), ('🥝', 'Kiwi')],
    [('🚗', 'Mobil'), ('🚌', 'Bus'), ('🚆', 'Kereta'), ('✈️', 'Pesawat'), ('🚁', 'Helikopter'), ('🚲', 'Sepeda'), ('🏍️', 'Motor'), ('🚜', 'Traktor'), ('🚢', 'Kapal')],
    [('🏠', 'Rumah'), ('📚', 'Buku'), ('⚽', 'Bola'), ('⏰', 'Jam'), ('🎒', 'Tas'), ('✏️', 'Pensil'), ('🧸', 'Boneka'), ('🪑', 'Kursi'), ('📱', 'Telepon')],
  ];

  List<(String, String)> get currentItems => _items[category];
  int get totalPages => (currentItems.length / 9).ceil();

  List<(String, String)> get visibleItems {
    final start = page * 9;
    final end = (start + 9).clamp(0, currentItems.length);
    return currentItems.sublist(start, end);
  }

  void _setCategory(int value) {
    setState(() {
      category = value;
      page = 0;
    });
    audio.click();
  }

  void _previous() {
    if (page == 0) return;
    setState(() => page--);
    audio.click();
  }

  void _next() {
    if (page >= totalPages - 1) return;
    setState(() => page++);
    audio.click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 390;
              return Column(
                children: [
                  _topBar(compact),
                  _tabs(compact),
                  Expanded(
                    child: _tab == 0
                        ? _lesson(compact)
                        : MiniQuizPanel(
                            questions: const [
                              MiniQuizQuestion(prompt: 'Gambar apakah ini?', visual: '🐱', choices: ['Kucing','Singa','Gajah','Kelinci'], answer: 'Kucing'),
                              MiniQuizQuestion(prompt: 'Pilih gambar yang sesuai nama!', visual: 'Rumah', choices: ['🏠','📚','⚽','🎒'], answer: '🏠'),
                              MiniQuizQuestion(prompt: 'Huruf awal gambar ini apa?', visual: '🍎\nApel', choices: ['A','B','C','D'], answer: 'A'),
                              MiniQuizQuestion(prompt: 'Mana yang termasuk HEWAN?', visual: 'Pilih gambar hewan', choices: ['🐘','🍌','🚗','📚'], answer: '🐘'),
                              MiniQuizQuestion(prompt: 'Pilih nama gambar yang benar!', visual: '🚆', choices: ['Kereta','Pesawat','Bus','Kapal'], answer: 'Kereta'),
                              MiniQuizQuestion(prompt: 'Mana yang termasuk BUAH?', visual: 'Pilih gambar buah', choices: ['🍓','🐼','🏠','🚲'], answer: '🍓'),
                              MiniQuizQuestion(prompt: 'Gambar apakah ini?', visual: '⚽', choices: ['Bola','Jam','Tas','Buku'], answer: 'Bola'),
                              MiniQuizQuestion(prompt: 'Pilih gambar yang sesuai nama!', visual: 'Ikan', choices: ['🐟','🐦','🐮','🦆'], answer: '🐟'),
                              MiniQuizQuestion(prompt: 'Mana yang termasuk KENDARAAN?', visual: 'Pilih satu', choices: ['🚁','🍊','🧸','🐰'], answer: '🚁'),
                              MiniQuizQuestion(prompt: 'Gambar apakah ini?', visual: '🦁', choices: ['Singa','Zebra','Jerapah','Panda'], answer: 'Singa'),
                            ],
                            totalQuestions: 10,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _tabs(bool compact) => Padding(
    padding: EdgeInsets.fromLTRB(compact ? 10 : 16, 0, compact ? 10 : 16, 6),
    child: Row(children: [
      Expanded(child: _tabButton('GAMBAR', 0, compact)),
      const SizedBox(width: 8),
      Expanded(child: _tabButton('MINI KUIS', 1, compact)),
    ]),
  );

  Widget _tabButton(String label, int value, bool compact) {
    final active = _tab == value;
    return Material(
      color: active ? Colors.white.withValues(alpha: .94) : Colors.white.withValues(alpha: .45),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () { setState(() => _tab = value); audio.click(); },
        child: SizedBox(height: compact ? 48 : 56, child: Center(child: Text(label, style: TextStyle(color: active ? const Color(0xFF244B78) : Colors.white, fontSize: compact ? 14 : 17, fontWeight: FontWeight.w900)))),
      ),
    );
  }

  Widget _lesson(bool compact) {
    final cardGap = compact ? 8.0 : 12.0;
    return Column(
      children: [
        _categoryBar(compact),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(compact ? 10 : 16, 10, compact ? 10 : 16, 8),
            child: GridView.builder(
              itemCount: visibleItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: cardGap,
                mainAxisSpacing: cardGap,
                childAspectRatio: compact ? 0.78 : 0.86,
              ),
              itemBuilder: (context, index) {
                final picture = visibleItems[index];
                return _pictureCard(emoji: picture.$1, label: picture.$2, compact: compact);
              },
            ),
          ),
        ),
        _bottomPager(),
      ],
    );
  }

  Widget _topBar(bool compact) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 10 : 16, 10, compact ? 10 : 16, 8),
      child: Row(
        children: [
          _roundButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              audio.click();
              Navigator.of(context).maybePop();
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Color(0x330D405C), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Belajar Gambar',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 24 : 29,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF163F7A),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Mengenal Benda di Sekitar Kita',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: compact ? 11 : 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF55758C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          _roundButton(
            icon: Icons.volume_up_rounded,
            onTap: () => audio.speak('Belajar gambar. Mengenal benda di sekitar kita.'),
          ),
        ],
      ),
    );
  }

  Widget _categoryBar(bool compact) {
    return SizedBox(
      height: compact ? 68 : 78,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = category == index;
          final categoryItem = _categories[index];

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => _setCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: compact ? 116 : 138,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(colors: [Color(0xFF2E8FF5), Color(0xFF1767C8)])
                      : null,
                  color: selected ? null : Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected ? const Color(0xFF0D5AB7) : const Color(0x88B7DCF0),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: selected ? const Color(0x44104D96) : const Color(0x220D405C),
                      blurRadius: selected ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${categoryItem.$1} ${categoryItem.$2}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF31536D),
                      fontSize: compact ? 15 : 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pictureCard({
    required String emoji,
    required String label,
    required bool compact,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(26),
      elevation: 5,
      shadowColor: const Color(0x330D405C),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          // Nama gambar harus terdengar bersih tanpa suara klik yang
          // bertumpuk dengan pengucapan, misalnya hanya "Buku".
          audio.speak(label);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(compact ? 4 : 8, compact ? 8 : 12, compact ? 4 : 8, compact ? 8 : 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(emoji, textAlign: TextAlign.center, style: const TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: compact ? 15 : 19,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF172C54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomPager() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
      child: Row(
        children: [
          _roundButton(icon: Icons.chevron_left_rounded, enabled: page > 0, onTap: _previous),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFF174E55),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x330D405C), blurRadius: 8, offset: Offset(0, 3)),
                  ],
                ),
                child: Text(
                  '${page + 1} / $totalPages',
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
          _roundButton(
            icon: Icons.chevron_right_rounded,
            enabled: page < totalPages - 1,
            onTap: _next,
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Material(
      color: enabled ? const Color(0xFFFFD45A) : Colors.white.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(22),
      elevation: enabled ? 5 : 0,
      shadowColor: const Color(0x330D405C),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 58,
          height: 58,
          child: Icon(
            icon,
            size: 34,
            color: enabled ? const Color(0xFF31536D) : const Color(0xFF91A5B2),
          ),
        ),
      ),
    );
  }
}
