import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==================== APP ====================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPM Sesi 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF3F8FC),
      ),
      home: const ProductProfilePage(),
    );
  }
}

// ==================== HALAMAN UTAMA ====================

class ProductProfilePage extends StatelessWidget {
  const ProductProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPM Sesi 2 - Istya Nadira Nurul Khadija (20240040144)',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Banner Promo
            const PromoBanner(),

            const SizedBox(height: 16),

            // Kartu Profil
            const ProfileCard(),

            const SizedBox(height: 16),

            // Kartu Produk
            const ProductCard(),
          ],
        ),
      ),
    );
  }
}

// ==================== BANNER PROMO ====================

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          const Positioned(
            left: 20,
            top: 20,
            child: Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 45,
            ),
          ),

          const Positioned(
            left: 80,
            top: 20,
            child: Text(
              'PROMO SPESIAL!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Positioned(
            left: 80,
            top: 58,
            child: Text(
              'Diskon hingga 30% untuk produk pilihan',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),

          Positioned(
            right: 15,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SHOP NOW',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PROFILE CARD ====================

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Foto / Ikon Profil
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.blue,
              ),
            ),

            const SizedBox(width: 20),

            // Informasi Mahasiswa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Istya Nadira Nurul Khadija',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'NIM: 20240040144',
                    style: TextStyle(fontSize: 14),
                  ),

                  const Text(
                    'Teknik Informatika / TI24G',
                    style: TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  // 5 Bintang
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PRODUCT CARD ====================

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  int likes = 10;
  int quantity = 1;

  final int price = 250000;

  // Fungsi Favorite
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;

      if (isFavorite) {
        likes++;
      } else {
        likes--;
      }
    });
  }

  // Fungsi tambah jumlah
  void tambahJumlah() {
    setState(() {
      quantity++;
    });
  }

  // Fungsi kurangi jumlah
  void kurangiJumlah() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalHarga = price * quantity;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================== GAMBAR PRODUK ====================

            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.headphones,
                size: 100,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 15),

            // ==================== NAMA PRODUK ====================

            const Text(
              'Headphone Wireless',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // ==================== KATEGORI ====================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Elektronik',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ==================== HARGA ====================

            const Text(
              'Rp250.000',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            // ==================== FAVORITE ====================

            Row(
              children: [
                IconButton(
                  onPressed: toggleFavorite,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : Colors.grey,
                    size: 30,
                  ),
                ),

                Text(
                  '$likes Like',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const Divider(),

            // ==================== JUMLAH PRODUK ====================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jumlah Produk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: kurangiJumlah,
                      icon: const Icon(Icons.remove),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: tambahJumlah,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ==================== TOTAL HARGA ====================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Rp$totalHarga',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ==================== BUTTON KERANJANG ====================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$quantity Headphone berhasil ditambahkan ke keranjang!',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}