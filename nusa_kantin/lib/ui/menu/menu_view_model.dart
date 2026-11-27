
import 'package:flutter/foundation.dart';

import '../../data/repositories/menu_repository.dart';
import '../../domain/models/menu_item.dart';

class MenuViewModel extends ChangeNotifier {
  final List<MenuItem> _daftarMenu = MenuRepository.daftarMenu;

  String _kategoriAktif = 'Semua';
  MenuItem? _menuTerpilih;

  final Map<String, int> _pesanan = {};

  List<MenuItem> get daftarMenu => _daftarMenu;

  String get kategoriAktif => _kategoriAktif;

  MenuItem? get menuTerpilih => _menuTerpilih;

  List<String> get daftarKategori => [
        'Semua',
        'Makanan',
        'Minuman',
      ];

  List<MenuItem> get menuTerfilter {
    if (_kategoriAktif == 'Semua') {
      return _daftarMenu;
    }

    return _daftarMenu
        .where((menu) => menu.kategori == _kategoriAktif)
        .toList();
  }

  Map<String, int> get daftarPesanan => Map.unmodifiable(_pesanan);

  int get jumlahPesanan {
    return _pesanan.values.fold(0, (total, jumlah) => total + jumlah);
  }

  int get totalHarga {
    int total = 0;

    for (final menu in _daftarMenu) {
      final jumlah = _pesanan[menu.id] ?? 0;
      total += menu.harga * jumlah;
    }

    return total;
  }

  void pilihKategori(String kategori) {
    _kategoriAktif = kategori;
    notifyListeners();
  }

  void pilihMenu(MenuItem menu) {
    _menuTerpilih = menu;
    notifyListeners();
  }

  void tambahPesanan(MenuItem menu) {
    _pesanan[menu.id] = (_pesanan[menu.id] ?? 0) + 1;
    notifyListeners();
  }

  void kurangiPesanan(MenuItem menu) {
    final jumlah = _pesanan[menu.id] ?? 0;

    if (jumlah > 1) {
      _pesanan[menu.id] = jumlah - 1;
    } else {
      _pesanan.remove(menu.id);
    }

    notifyListeners();
  }

  int jumlahMenu(MenuItem menu) {
    return _pesanan[menu.id] ?? 0;
  }
}
