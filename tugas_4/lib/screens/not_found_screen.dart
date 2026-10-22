import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class NotFoundScreen extends StatelessWidget {
  final String routeName;

  const NotFoundScreen({
    super.key,
    this.routeName = 'unknown',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.travel_explore,
                size: 76,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 16),

              const Text(
                '404',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ups! Halaman yang kamu cari tidak ditemukan.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Rute: $routeName',
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}