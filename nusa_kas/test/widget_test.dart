
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/main.dart';

void main() {
  testWidgets('Aplikasi NusaKas berhasil ditampilkan',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NusaKasApp());

    expect(find.text('NusaKas'), findsOneWidget);
  });
}
