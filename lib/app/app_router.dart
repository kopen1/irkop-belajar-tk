import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/huruf/huruf_page.dart';
import '../features/angka/angka_page.dart';
import '../features/hijaiyah/hijaiyah_page.dart';
import '../features/gambar/gambar_page.dart';
import '../features/warna/warna_page.dart';
import '../features/mewarnai/mewarnai_page.dart';
import '../features/titik_garis/titik_garis_page.dart';
import '../features/kuis/kuis_page.dart';

class AppRouter {
  AppRouter._();

  static const home = '/';

  static const huruf = '/huruf';
  static const angka = '/angka';
  static const hijaiyah = '/hijaiyah';
  static const gambar = '/gambar';
  static const warna = '/warna';
  static const mewarnai = '/mewarnai';
  static const titikGaris = '/titik-garis';
  static const kuis = '/kuis';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _page(const HomePage());

      case huruf:
        return _page(const HurufPage());

      case angka:
        return _page(const AngkaPage());

      case hijaiyah:
        return _page(const HijaiyahPage());

      case gambar:
        return _page(const GambarPage());

      case warna:
        return _page(const WarnaPage());

      case mewarnai:
        return _page(const MewarnaiPage());

      case titikGaris:
        return _page(const TitikGarisPage());

      case kuis:
        return _page(const KuisPage());

      default:
        return _page(const HomePage());
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child) {
    return MaterialPageRoute(
      builder: (_) => child,
    );
  }
}
