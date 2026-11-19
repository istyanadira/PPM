
import 'models/transaksi.dart';

class KasCalculator {
  // Menghitung seluruh pemasukan
  double totalPemasukan(List<Transaksi> transaksi) {
    return transaksi
        .where((item) => item.jenis == JenisTransaksi.pemasukan)
        .fold(0.0, (total, item) => total + item.nominal);
  }

  // Menghitung seluruh pengeluaran
  double totalPengeluaran(List<Transaksi> transaksi) {
    return transaksi
        .where((item) => item.jenis == JenisTransaksi.pengeluaran)
        .fold(0.0, (total, item) => total + item.nominal);
  }

  // Menghitung saldo akhir
  double hitungSaldo(List<Transaksi> transaksi) {
    return totalPemasukan(transaksi) -
        totalPengeluaran(transaksi);
  }
}
