
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/transaksi.dart';
import 'kas_view_model.dart';

class TambahTransaksiScreen extends StatefulWidget {
  final KasViewModel viewModel;

  const TambahTransaksiScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<TambahTransaksiScreen> createState() =>
      _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState
    extends State<TambahTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();

  final _keteranganController = TextEditingController();
  final _nominalController = TextEditingController();

  JenisTransaksi _jenis = JenisTransaksi.pemasukan;

  @override
  void dispose() {
    _keteranganController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  // Menyimpan transaksi
  void _simpanTransaksi() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nominal = double.tryParse(
      _nominalController.text.trim(),
    );

    if (nominal == null || nominal <= 0) {
      return;
    }

    try {
      widget.viewModel.tambahTransaksi(
        keterangan: _keteranganController.text.trim(),
        nominal: nominal,
        jenis: _jenis,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Catat Transaksi Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Masukkan informasi transaksi kas himpunan.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 28),

              // Form keterangan
              const Text(
                'Keterangan Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                key: const Key('keterangan_field'),
                controller: _keteranganController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Iuran anggota',
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Keterangan wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 22),

              // Form nominal
              const Text(
                'Nominal (Rupiah)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                key: const Key('nominal_field'),
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: 'Contoh: 50000',
                  prefixIcon: const Icon(Icons.payments),
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nominal wajib diisi';
                  }

                  final nominal = double.tryParse(value);

                  if (nominal == null) {
                    return 'Nominal harus berupa angka';
                  }

                  if (nominal <= 0) {
                    return 'Nominal harus lebih besar dari nol';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 22),

              // Pilihan jenis transaksi
              const Text(
                'Jenis Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<JenisTransaksi>(
                key: const Key('jenis_field'),
                initialValue: _jenis,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: JenisTransaksi.pemasukan,
                    child: Text('Pemasukan'),
                  ),
                  DropdownMenuItem(
                    value: JenisTransaksi.pengeluaran,
                    child: Text('Pengeluaran'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _jenis = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 35),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  key: const Key('simpan_button'),
                  onPressed: _simpanTransaksi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16834A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
