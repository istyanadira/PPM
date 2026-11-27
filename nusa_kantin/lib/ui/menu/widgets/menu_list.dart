
import 'package:flutter/material.dart';

import '../../../../domain/models/menu_item.dart';

class MenuList extends StatelessWidget {
  final List<MenuItem> menus;
  final MenuItem? menuTerpilih;
  final ValueChanged<MenuItem> onMenuTap;
  final ValueChanged<MenuItem> onTambah;

  const MenuList({
    super.key,
    required this.menus,
    required this.menuTerpilih,
    required this.onMenuTap,
    required this.onTambah,
  });

  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    if (menus.isEmpty) {
      return const Center(
        child: Text('Menu tidak ditemukan.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        final terpilih = menuTerpilih?.id == menu.id;

        return Card(
          elevation: terpilih ? 3 : 1,
          color: terpilih ? Colors.green.shade50 : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: terpilih
                  ? Colors.green
                  : Colors.grey.shade200,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onMenuTap(menu),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      menu.kategori == 'Makanan'
                          ? Icons.restaurant
                          : Icons.local_cafe,
                      color: Colors.green.shade800,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          menu.kategori,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatRupiah(menu.harga),
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tambah pesanan ${menu.nama}',
                    onPressed: () => onTambah(menu),
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
