
import 'package:flutter/material.dart';

import '../menu/menu_view_model.dart';
import '../../domain/models/menu_item.dart';

class PesananScreen extends StatelessWidget {
  final MenuViewModel viewModel;

  const PesananScreen({
    super.key,
    required this.viewModel,
  });

  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final pesanan = viewModel.daftarMenu.where(
          (menu) => viewModel.jumlahMenu(menu) > 0,
        ).toList();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${viewModel.jumlahPesanan} item dalam pesanan',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: pesanan.isEmpty
                      ? _buildEmptyState()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 600) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildOrderList(pesanan),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 260,
                                    child: _buildSummary(),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                Expanded(
                                  child: _buildOrderList(pesanan),
                                ),
                                const SizedBox(height: 16),
                                _buildSummary(),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderList(List<MenuItem> pesanan) {
    return ListView.builder(
      itemCount: pesanan.length,
      itemBuilder: (context, index) {
        final menu = pesanan[index];
        final jumlah = viewModel.jumlahMenu(menu);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    menu.kategori == 'Makanan'
                        ? Icons.restaurant
                        : Icons.local_cafe,
                    color: Colors.green.shade700,
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(menu.harga),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Kurangi ${menu.nama}',
                  onPressed: () => viewModel.kurangiPesanan(menu),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '$jumlah',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  tooltip: 'Tambah ${menu.nama}',
                  onPressed: () => viewModel.tambahPesanan(menu),
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummary() {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Item'),
                Text('${viewModel.jumlahPesanan} item'),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Total Pembayaran',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formatRupiah(viewModel.totalHarga),
              style: TextStyle(
                color: Colors.green.shade800,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 75,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Pesanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk, pilih menu favoritmu terlebih dahulu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
