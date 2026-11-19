
import '../../domain/models/transaksi.dart';

class TransaksiRepository {
  final List<Transaksi> _transaksi = [];

  // Mengambil semua transaksi
  List<Transaksi> getAll() {
    return List.unmodifiable(_transaksi);
  }

  // Menambahkan transaksi
  void tambahTransaksi(Transaksi transaksi) {
    _transaksi.add(transaksi);
  }

  // Menghapus transaksi berdasarkan ID
  void hapusTransaksi(String id) {
    _transaksi.removeWhere(
      (transaksi) => transaksi.id == id,
    );
  }

  // Menghapus semua transaksi
  void hapusSemua() {
    _transaksi.clear();
  }
}
