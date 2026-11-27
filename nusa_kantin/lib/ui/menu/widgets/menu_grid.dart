
import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';

class MenuGrid extends StatelessWidget {
  final List<MenuItem> menus;
  final MenuItem? menuTerpilih;
  final ValueChanged<MenuItem> onMenuTap;
  final ValueChanged<MenuItem> onTambah;

  const MenuGrid({
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

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 190,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        final terpilih = menuTerpilih?.id == menu.id;

        return Card(
          elevation: terpilih ? 3 : 1,
          color: terpilih ? Colors.green.shade50 : Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        menu.kategori == 'Makanan'
                            ? Icons.restaurant
                            : Icons.local_cafe,
                        size: 48,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  Text(
                    menu.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(menu.harga),
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Tambah ${menu.nama}',
                      onPressed: () => onTambah(menu),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      ),
                      visualDensity: VisualDensity.compact,
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
