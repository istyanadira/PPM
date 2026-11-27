
import '../../domain/models/menu_item.dart';

class MenuRepository {
  static const List<MenuItem> daftarMenu = [
    MenuItem(
      id: '1',
      nama: 'Nasi Goreng Spesial',
      kategori: 'Makanan',
      harga: 15000,
      deskripsi: 'Nasi goreng dengan telur, ayam, dan sayuran segar.',
    ),
    MenuItem(
      id: '2',
      nama: 'Mie Ayam',
      kategori: 'Makanan',
      harga: 12000,
      deskripsi: 'Mie kenyal dengan topping ayam berbumbu dan sayuran.',
    ),
    MenuItem(
      id: '3',
      nama: 'Ayam Geprek',
      kategori: 'Makanan',
      harga: 18000,
      deskripsi: 'Ayam crispy dengan sambal pedas dan nasi hangat.',
    ),
    MenuItem(
      id: '4',
      nama: 'Nasi Ayam Bakar',
      kategori: 'Makanan',
      harga: 20000,
      deskripsi: 'Nasi putih dengan ayam bakar bumbu khas dan lalapan.',
    ),
    MenuItem(
      id: '5',
      nama: 'Bakso Kuah',
      kategori: 'Makanan',
      harga: 13000,
      deskripsi: 'Bakso sapi dengan kuah gurih dan mie.',
    ),
    MenuItem(
      id: '6',
      nama: 'Es Teh Manis',
      kategori: 'Minuman',
      harga: 5000,
      deskripsi: 'Teh manis segar dengan es batu.',
    ),
    MenuItem(
      id: '7',
      nama: 'Es Jeruk',
      kategori: 'Minuman',
      harga: 7000,
      deskripsi: 'Minuman jeruk segar dengan rasa manis dan sedikit asam.',
    ),
    MenuItem(
      id: '8',
      nama: 'Kopi Susu',
      kategori: 'Minuman',
      harga: 10000,
      deskripsi: 'Perpaduan kopi dan susu dengan rasa creamy.',
    ),
    MenuItem(
      id: '9',
      nama: 'Jus Alpukat',
      kategori: 'Minuman',
      harga: 12000,
      deskripsi: 'Jus alpukat segar dengan susu cokelat.',
    ),
    MenuItem(
      id: '10',
      nama: 'Air Mineral',
      kategori: 'Minuman',
      harga: 4000,
      deskripsi: 'Air mineral kemasan untuk menemani aktivitas.',
    ),
  ];
}
