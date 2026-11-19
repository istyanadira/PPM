
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nusa_kas/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Menambahkan pemasukan dan pengeluaran lalu memeriksa saldo',
    (WidgetTester tester) async {
      // Membuka aplikasi NusaKas.
      await tester.pumpWidget(const NusaKasApp());
      await tester.pumpAndSettle();

      // Memastikan halaman utama tampil.
      expect(find.text('NusaKas'), findsOneWidget);

      // Membuka halaman tambah transaksi.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Mengisi pemasukan.
      await tester.enterText(
        find.byKey(const Key('keterangan_field')),
        'Iuran anggota',
      );

      await tester.enterText(
        find.byKey(const Key('nominal_field')),
        '200000',
      );

      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // Memastikan kembali ke halaman utama.
      expect(find.text('NusaKas'), findsOneWidget);

      // Membuka halaman tambah transaksi lagi.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Mengisi pengeluaran.
      await tester.enterText(
        find.byKey(const Key('keterangan_field')),
        'Beli perlengkapan',
      );

      await tester.enterText(
        find.byKey(const Key('nominal_field')),
        '50000',
      );

      // Mengubah jenis transaksi menjadi pengeluaran.
      await tester.tap(find.byKey(const Key('jenis_field')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pengeluaran').last);
      await tester.pumpAndSettle();

      // Menyimpan pengeluaran.
      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // Memastikan saldo akhir Rp150.000.
      expect(
        find.textContaining('150.000'),
        findsWidgets,
      );
    },
  );
}
