import 'package:flutter_test/flutter_test.dart';
import 'package:irkop_belajar_tk/app/irkop_app.dart';

void main() {
  testWidgets(
    'Home menampilkan IRKOP dan menu belajar',
    (tester) async {
      await tester.pumpWidget(const IrkopApp());

      expect(find.text('IRKOP'), findsOneWidget);
      expect(find.text('Dunia Huruf'), findsOneWidget);
      expect(find.text('Kuis Seru'), findsOneWidget);
    },
  );
}
