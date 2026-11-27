
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kantin/main.dart';

void main() {
  testWidgets('NusaKantin berhasil ditampilkan', (WidgetTester tester) async {
    await tester.pumpWidget(const NusaKantinApp());

    expect(find.text('Halo, Selamat Datang!'), findsOneWidget);
    expect(find.text('Menu Kantin'), findsOneWidget);
  });
}