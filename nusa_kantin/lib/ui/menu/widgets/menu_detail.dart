
import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';

class MenuDetail extends StatelessWidget {
  final MenuItem? menu;
  final VoidCallback? onTambah;

  const MenuDetail({
    super.key,
    required this.menu,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactPanel = constraints.maxWidth < 300;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: menu == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: compactPanel ? 48 : 80,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih salah satu menu untuk melihat detailnya.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: compactPanel ? 110 : 180,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          menu!.kategori == 'Makanan'
                              ? Icons.restaurant
                              : Icons.local_cafe,
                          size: compactPanel ? 55 : 90,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      menu!.kategori.toUpperCase(),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menu!.nama,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatRupiah(menu!.harga),
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Deskripsi Menu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menu!.deskripsi,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onTambah,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Tambah ke Pesanan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
