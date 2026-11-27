
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kantin/main.dart';

void main() {
  // TEST 1: Responsive layout HP dan tablet
  testWidgets(
    'Responsive layout berjalan pada HP dan tablet',
    (WidgetTester tester) async {
      // Pengaturan ukuran layar HP
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NusaKantinApp());
      await tester.pumpAndSettle();

      // HP menggunakan NavigationBar
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);

      // HP menampilkan ListView
      expect(find.byType(ListView), findsOneWidget);

      // Pengaturan ukuran tablet medium
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpAndSettle();

      // Tablet medium menggunakan NavigationRail
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      // Tablet medium menampilkan GridView
      expect(find.byType(GridView), findsOneWidget);

      // Pengaturan ukuran tablet expanded
      tester.view.physicalSize = const Size(1024, 768);
      await tester.pumpAndSettle();

      // Tablet expanded menggunakan NavigationRail
      expect(find.byType(NavigationRail), findsOneWidget);

      // Tablet expanded menampilkan GridView
      expect(find.byType(GridView), findsOneWidget);

      // Memastikan tidak ada error
      expect(tester.takeException(), isNull);
    },
  );

  // TEST 2: Tampilan HP landscape
  testWidgets(
    'Aplikasi berjalan pada posisi landscape',
    (WidgetTester tester) async {
      // Ukuran layar landscape
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NusaKantinApp());
      await tester.pumpAndSettle();

      // Memastikan navigasi tersedia
      expect(find.byType(NavigationRail), findsOneWidget);

      // Membuka halaman Pesanan
      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Pesanan Saya'), findsOneWidget);

      // Memastikan tidak ada overflow atau exception
      expect(tester.takeException(), isNull);
    },
  );

  // TEST 3: Pembesaran teks 200%
  testWidgets(
    'Aplikasi tidak mengalami error saat teks diperbesar 200%',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(2.0),
                ),
                child: const MainNavigationScreen(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Memastikan halaman Menu tetap tampil
      expect(find.text('Menu Kantin'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      // Memastikan tidak ada exception pada teks 200%
      expect(tester.takeException(), isNull);

      // Membuka halaman Pesanan
      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Pesanan Saya'), findsOneWidget);

      // Memastikan halaman Pesanan juga tidak mengalami error
      expect(tester.takeException(), isNull);
    },
  );
}
