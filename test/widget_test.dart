import 'package:flutter_test/flutter_test.dart';

import 'package:irkop_belajar_tk/main.dart';

void main() {
  testWidgets('Aplikasi IRKOP dapat dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const IrkopApp());
    await tester.pump();

    expect(find.byType(IrkopApp), findsOneWidget);
  });
}
