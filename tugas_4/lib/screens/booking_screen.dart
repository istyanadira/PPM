import 'package:flutter/material.dart';
import '../models/tour_package.dart';

class BookingScreen extends StatefulWidget {
  final TourPackage package;

  const BookingScreen({
    super.key,
    required this.package,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _participantsController =
      TextEditingController(text: '1');

  DateTime? _departureDate;

  bool _allowPop = false;

  @override
  void dispose() {
    _nameController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      helpText: 'Pilih tanggal keberangkatan',
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _departureDate = selectedDate;
      });
    }
  }

  Future<void> confirmBack() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Batalkan pemesanan?'),
          content: const Text(
            'Data pemesanan yang belum dikirim akan hilang. '
            'Kamu yakin ingin kembali?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Tetap di halaman'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Ya, kembali'),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true && mounted) {
      setState(() {
        _allowPop = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  void submitBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal keberangkatan.'),
        ),
      );
      return;
    }

    // Mengirim hasil pemesanan kembali ke Detail Screen.
    Navigator.pop<Map<String, dynamic>>(context, {
      'name': _nameController.text.trim(),
      'participants':
          int.parse(_participantsController.text.trim()),
      'departureDate': _departureDate!.toIso8601String(),
      'packageId': widget.package.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _departureDate == null
        ? 'Pilih tanggal keberangkatan'
        : '${_departureDate!.day.toString().padLeft(2, '0')}/'
            '${_departureDate!.month.toString().padLeft(2, '0')}/'
            '${_departureDate!.year}';

    return PopScope<Object?>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_allowPop) {
          confirmBack();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Pemesanan'),
        ),

        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.package.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Lengkapi data berikut untuk memesan paket wisata.',
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama pemesan',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _participantsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah peserta',
                  prefixIcon: Icon(Icons.groups_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final count = int.tryParse(value ?? '');

                  if (count == null || count < 1) {
                    return 'Masukkan jumlah peserta minimal 1.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: chooseDate,
                icon: const Icon(Icons.calendar_month),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(dateLabel),
                ),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: submitBooking,
                icon: const Icon(Icons.check_circle_outline),
                label: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Text('Konfirmasi Pemesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}