
import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import 'kas_view_model.dart';
import 'tambah_transaksi_screen.dart';

class HomeScreen extends StatelessWidget {
  final KasViewModel viewModel;

  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  // Format nominal menjadi Rupiah
  String formatRupiah(double nominal) {
    final angka = nominal.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      buffer.write(angka[i]);

      final sisa = angka.length - i - 1;

      if (sisa > 0 && sisa % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  // Format tanggal transaksi
  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final daftarTransaksi = viewModel.transaksi;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F5),

          // AppBar
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF16834A),
                ),
                SizedBox(width: 10),
                Text(
                  'NusaKas',
                  style: TextStyle(
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Konten utama
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu saldo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16834A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Saldo Kas',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatRupiah(viewModel.saldo),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Keuangan Himpunan',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Ringkasan keuangan
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Pemasukan',
                        amount: formatRupiah(
                          viewModel.totalPemasukan,
                        ),
                        icon: Icons.arrow_downward,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Pengeluaran',
                        amount: formatRupiah(
                          viewModel.totalPengeluaran,
                        ),
                        icon: Icons.arrow_upward,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Judul riwayat transaksi
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Daftar transaksi
                if (daftarTransaksi.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tambahkan transaksi pertamamu.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: daftarTransaksi.length,
                    itemBuilder: (context, index) {
                      final transaksi =
                          daftarTransaksi[index];

                      final isPemasukan =
                          transaksi.jenis ==
                              JenisTransaksi.pemasukan;

                      return Dismissible(
                        key: ValueKey(transaksi.id),
                        direction:
                            DismissDirection.endToStart,

                        background: Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),

                        onDismissed: (direction) {
                          viewModel.hapusTransaksi(
                            transaksi.id,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Transaksi berhasil dihapus',
                              ),
                            ),
                          );
                        },

                        child: _buildTransactionItem(
                          transaksi,
                          isPemasukan,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Tombol tambah transaksi
          floatingActionButton:
              FloatingActionButton.extended(
            backgroundColor: const Color(0xFF16834A),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Transaksi'),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TambahTransaksiScreen(
                    viewModel: viewModel,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Widget ringkasan pemasukan dan pengeluaran
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 25,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget item transaksi
  Widget _buildTransactionItem(
    Transaksi transaksi,
    bool isPemasukan,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isPemasukan
                ? Colors.green.shade50
                : Colors.red.shade50,
            child: Icon(
              isPemasukan
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: isPemasukan
                  ? Colors.green
                  : Colors.red,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.keterangan,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatTanggal(transaksi.tanggal),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '${isPemasukan ? '+' : '-'}'
            '${formatRupiah(transaksi.nominal)}',
            style: TextStyle(
              color: isPemasukan
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
