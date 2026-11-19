
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_kas/domain/kas_calculator.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';

void main() {
  late KasCalculator calculator;
  late KasViewModel viewModel;

  setUp(() {
    calculator = KasCalculator();
    viewModel = KasViewModel();
  });

  Transaksi buatTransaksi({
    required String id,
    required double nominal,
    required JenisTransaksi jenis,
  }) {
    return Transaksi(
      id: id,
      keterangan: 'Transaksi $id',
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime.now(),
    );
  }

  group('Unit Test KasCalculator', () {
    test('1. Total pemasukan kosong harus 0', () {
      expect(calculator.totalPemasukan([]), 0);
    });

    test('2. Total pengeluaran kosong harus 0', () {
      expect(calculator.totalPengeluaran([]), 0);
    });

    test('3. Saldo kosong harus 0', () {
      expect(calculator.hitungSaldo([]), 0);
    });

    test('4. Menghitung total pemasukan dengan benar', () {
      final transaksi = [
        buatTransaksi(
          id: '1',
          nominal: 100000,
          jenis: JenisTransaksi.pemasukan,
        ),
        buatTransaksi(
          id: '2',
          nominal: 50000,
          jenis: JenisTransaksi.pemasukan,
        ),
      ];

      expect(calculator.totalPemasukan(transaksi), 150000);
    });

    test('5. Menghitung total pengeluaran dengan benar', () {
      final transaksi = [
        buatTransaksi(
          id: '1',
          nominal: 30000,
          jenis: JenisTransaksi.pengeluaran,
        ),
        buatTransaksi(
          id: '2',
          nominal: 20000,
          jenis: JenisTransaksi.pengeluaran,
        ),
      ];

      expect(calculator.totalPengeluaran(transaksi), 50000);
    });

    test('6. Menghitung saldo dengan benar', () {
      final transaksi = [
        buatTransaksi(
          id: '1',
          nominal: 200000,
          jenis: JenisTransaksi.pemasukan,
        ),
        buatTransaksi(
          id: '2',
          nominal: 75000,
          jenis: JenisTransaksi.pengeluaran,
        ),
      ];

      expect(calculator.hitungSaldo(transaksi), 125000);
    });
  });

  group('Unit Test Validasi Transaksi', () {
    test('7. Nominal nol harus ditolak', () {
      expect(
        () => viewModel.tambahTransaksi(
          keterangan: 'Iuran',
          nominal: 0,
          jenis: JenisTransaksi.pemasukan,
        ),
        throwsArgumentError,
      );
    });

    test('8. Nominal negatif harus ditolak', () {
      expect(
        () => viewModel.tambahTransaksi(
          keterangan: 'Iuran',
          nominal: -10000,
          jenis: JenisTransaksi.pemasukan,
        ),
        throwsArgumentError,
      );
    });

    test('9. Pengeluaran melebihi saldo harus ditolak', () {
      viewModel.tambahTransaksi(
        keterangan: 'Iuran anggota',
        nominal: 100000,
        jenis: JenisTransaksi.pemasukan,
      );

      expect(
        () => viewModel.tambahTransaksi(
          keterangan: 'Beli perlengkapan',
          nominal: 150000,
          jenis: JenisTransaksi.pengeluaran,
        ),
        throwsArgumentError,
      );
    });

    test('10. Pengeluaran sesuai saldo harus diterima', () {
      viewModel.tambahTransaksi(
        keterangan: 'Iuran anggota',
        nominal: 100000,
        jenis: JenisTransaksi.pemasukan,
      );

      viewModel.tambahTransaksi(
        keterangan: 'Beli perlengkapan',
        nominal: 100000,
        jenis: JenisTransaksi.pengeluaran,
      );

      expect(viewModel.saldo, 0);
    });
  });
}
