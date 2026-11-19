
import 'package:flutter/foundation.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/kas_calculator.dart';
import '../../domain/models/transaksi.dart';

class KasViewModel extends ChangeNotifier {
  final TransaksiRepository _repository;
  final KasCalculator _calculator;

  KasViewModel({
    TransaksiRepository? repository,
    KasCalculator? calculator,
  })  : _repository = repository ?? TransaksiRepository(),
        _calculator = calculator ?? KasCalculator();

  // Mengambil daftar transaksi
  List<Transaksi> get transaksi => _repository.getAll();

  // Menghitung total pemasukan
  double get totalPemasukan =>
      _calculator.totalPemasukan(transaksi);

  // Menghitung total pengeluaran
  double get totalPengeluaran =>
      _calculator.totalPengeluaran(transaksi);

  // Menghitung saldo
  double get saldo => _calculator.hitungSaldo(transaksi);

  // Menambahkan transaksi baru
  void tambahTransaksi({
    required String keterangan,
    required double nominal,
    required JenisTransaksi jenis,
  }) {
    // Validasi nominal
    if (nominal <= 0) {
      throw ArgumentError(
        'Nominal harus lebih besar dari nol.',
      );
    }

    // Validasi pengeluaran tidak boleh melebihi saldo
    if (jenis == JenisTransaksi.pengeluaran &&
        nominal > saldo) {
      throw ArgumentError(
        'Pengeluaran melebihi saldo yang tersedia.',
      );
    }

    // Membuat transaksi baru
    final transaksiBaru = Transaksi(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      keterangan: keterangan,
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime.now(),
    );

    _repository.tambahTransaksi(transaksiBaru);

    // Memberitahu widget bahwa data berubah
    notifyListeners();
  }

  // Menghapus transaksi
  void hapusTransaksi(String id) {
    _repository.hapusTransaksi(id);
    notifyListeners();
  }
}
