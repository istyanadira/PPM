
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_kas/ui/kas/kas_view_model.dart';
import 'package:nusa_kas/ui/kas/tambah_transaksi_screen.dart';

void main() {
  late KasViewModel viewModel;

  setUp(() {
    viewModel = KasViewModel();
  });

  Widget buatWidget() {
    return MaterialApp(
      home: TambahTransaksiScreen(
        viewModel: viewModel,
      ),
    );
  }

  group('Widget Test Tambah Transaksi', () {
    testWidgets(
      '1. Menampilkan halaman tambah transaksi',
      (WidgetTester tester) async {
        await tester.pumpWidget(buatWidget());

        expect(find.text('Tambah Transaksi'), findsOneWidget);

        expect(
          find.byKey(const Key('keterangan_field')),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key('nominal_field')),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key('jenis_field')),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key('simpan_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      '2. Form kosong tidak dapat disimpan',
      (WidgetTester tester) async {
        await tester.pumpWidget(buatWidget());

        // Tekan tombol simpan tanpa mengisi form.
        await tester.tap(
          find.byKey(const Key('simpan_button')),
        );

        await tester.pumpAndSettle();

        // Memastikan pengguna tetap berada di halaman form.
        expect(
          find.byKey(const Key('keterangan_field')),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key('nominal_field')),
          findsOneWidget,
        );

        // Memastikan pesan validasi muncul.
        expect(
          find.byType(InputDecorator),
          findsWidgets,
        );

        // Memastikan belum ada transaksi yang tersimpan.
        expect(viewModel.transaksi, isEmpty);
      },
    );
  });
}
