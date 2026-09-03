import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:irkop_belajar_tk/core/theme/kids_theme.dart';
import 'package:irkop_belajar_tk/features/home/home_page.dart';

void main() {
  testWidgets('home page renders the eight learning worlds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KidsTheme.data(),
        home: const HomePage(),
      ),
    );

    expect(find.text('Dunia Huruf'), findsOneWidget);
    expect(find.text('Dunia Angka'), findsOneWidget);
    expect(find.text('Dunia Hijaiyah'), findsOneWidget);
    expect(find.text('Dunia Gambar'), findsOneWidget);
    expect(find.text('Dunia Warna'), findsOneWidget);
    expect(find.text('Mewarnai'), findsOneWidget);
    expect(find.text('Titik & Garis'), findsOneWidget);
    expect(find.text('Kuis Seru'), findsOneWidget);
  });
}
