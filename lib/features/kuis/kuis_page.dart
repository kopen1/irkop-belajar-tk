import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});
  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _Question {
  final String prompt;
  final String answer;
  final List<(String, String)> options;
  const _Question(this.prompt, this.answer, this.options);
}

class _KuisPageState extends State<KuisPage> {
  final audio = AudioService.instance;
  final random = Random();
  late final ConfettiController confetti;
  int number = 1;
  bool? result;
  late _Question question;

  final bank = const [
    _Question('Mana gambar ikan?', 'Ikan', [('🐱','Kucing'),('🐟','Ikan'),('🚗','Mobil')]),
    _Question('Mana gambar apel?', 'Apel', [('🍎','Apel'),('⚽','Bola'),('🐘','Gajah')]),
    _Question('Mana warna merah?', 'Merah', [('🔵','Biru'),('🔴','Merah'),('🟢','Hijau')]),
  ];

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    question = bank.first;
    WidgetsBinding.instance.addPostFrameCallback((_) => audio.question(question.prompt));
  }

  Future<void> choose(String value) async {
    if (result != null) return;
    final ok = value == question.answer;
    setState(() => result = ok);
    if (ok) {
      confetti.play();
      await audio.correct();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        number++;
        question = bank[random.nextInt(bank.length)];
        result = null;
      });
      audio.question(question.prompt);
    } else {
      await audio.wrong();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) setState(() => result = null);
    }
  }

  @override
  void dispose() { confetti.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: KidBackground(child: SafeArea(child: Stack(children: [
      Column(children: [
        _header(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 12, offset: Offset(0, 6))]),
            child: Column(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7), decoration: BoxDecoration(color: const Color(0xFF56B9E8), borderRadius: BorderRadius.circular(18)), child: Text('Pertanyaan $number', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))),
              const SizedBox(height: 16),
              Text(question.prompt, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF17223B))),
              const SizedBox(height: 20),
              Row(children: question.options.map((o) {
                return Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Material(color: Colors.white, borderRadius: BorderRadius.circular(22), elevation: 3, child: InkWell(
                  onTap: () => choose(o.$2),
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(height: 132, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(o.$1, style: const TextStyle(fontSize: 62)),
                    Text(o.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ])),
                ))));
              }).toList()),
            ]),
          ),
        ),
      ]),
      Align(alignment: Alignment.topCenter, child: ConfettiWidget(confettiController: confetti, blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 38, gravity: .25)),
      if (result != null) _feedback(result!),
    ]))));
  }

  Widget _header() => SizedBox(height: 92, child: Stack(alignment: Alignment.center, children: [
    Positioned(left: 22, child: Material(color: const Color(0xFFFFC42D), shape: const CircleBorder(), elevation: 5, child: InkWell(customBorder: const CircleBorder(), onTap: () => Navigator.of(context).maybePop(), child: const SizedBox(width: 62, height: 62, child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 36)))),
    Positioned(right: 22, child: const CircleAvatar(radius: 31, backgroundColor: Color(0xFF29C63E), child: Icon(Icons.music_note_rounded, color: Colors.white, size: 34))),
    Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Text('🏆 Kuis Seru', style: TextStyle(fontSize: 35, color: Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
      Text('Ayo Jawab Pertanyaannya!', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w900)),
    ]),
  ]));

  Widget _feedback(bool correct) => Positioned.fill(
    child: Container(
      color: (correct ? const Color(0xFF42C95A) : const Color(0xFFFF746C)).withValues(alpha: .96),
      child: SafeArea(child: Stack(children: [
        const Positioned(top: 45, left: 28, child: Text('⭐', style: TextStyle(fontSize: 42))),
        const Positioned(top: 120, right: 35, child: Text('🎵', style: TextStyle(fontSize: 38))),
        const Positioned(bottom: 120, left: 32, child: Text('✨', style: TextStyle(fontSize: 44))),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(correct ? '🦕' : '🐯', style: const TextStyle(fontSize: 180)),
          const SizedBox(height: 8),
          Text(correct ? 'Hebat!' : 'Coba lagi ya!', style: const TextStyle(color: Color(0xFFFFF3A8), fontSize: 52, fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0x99000000), blurRadius: 4, offset: Offset(2, 4))])),
          const SizedBox(height: 8),
          Text(correct ? 'Jawaban kamu benar!' : 'Tidak apa-apa, coba sekali lagi.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
        ]),
      ])),
    ),
  );
}
