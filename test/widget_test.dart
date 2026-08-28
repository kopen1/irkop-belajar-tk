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
