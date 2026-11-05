import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_info/main.dart';

void main() {
  testWidgets('NusaInfo app can be created',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NusaInfoApp());

    expect(find.byType(NusaInfoApp), findsOneWidget);
  });
}