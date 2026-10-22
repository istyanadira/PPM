import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final TourPackage package;

  const DetailScreen({
    super.key,
    required this.package,
  });

  String formatRupiah(int price) {
    final value = price.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);

      final remaining = value.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp${buffer.toString()}';
  }

  Future<void> bookPackage(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingScreen(package: package);
        },
      ),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Booking berhasil! ${result['name']} '
              'memesan untuk ${result['participants']} peserta.',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Paket Wisata'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              package.imageUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 240,
                  color: Colors.teal.shade50,
                  child: const Center(
                    child: Icon(
                      Icons.landscape,
                      size: 70,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Text(
            package.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Kode paket: ${package.id}',
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 14),

          Text(
            package.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '${formatRupiah(package.price)} / orang',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: () => bookPackage(context),
            icon: const Icon(Icons.calendar_month),
            label: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Pesan Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}