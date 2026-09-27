import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPM Sesi 1 - Istya Nadira Nurul Khadija (20240040144)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Mengubah warna tema utama menjadi Indigo (atau sesuaikan sesuai keinginan)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Ubah data identitas di bawah ini sesuai kebutuhan Anda
  final String nama = 'Istya Nadira Nurul Khadija';
  final String nim = '20240040144';
  final String prodiKelas = 'Informatika / TI24G';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      } else {
        // Tampilkan SnackBar jika menekan tombol minus saat counter sudah 0
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Counter tidak boleh kurang dari 0!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEven = _counter % 2 == 0;

    return Scaffold(
      appBar: AppBar(
        // Title AppBar format: PPM Sesi 1 - Nama (NIM)
        title: Text('PPM Sesi 1 - $nama ($nim)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kartu Identitas
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('NIM: $nim'),
                            Text('Prodi/Kelas: $prodiKelas'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Nilai Counter saat ini:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              // Angka Counter dengan Warna Berbeda (Genap / Ganjil)
              Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: isEven ? Colors.blue : Colors.orange,
                ),
              ),

              // Status Genap / Ganjil
              Text(
                isEven ? 'Angka Genap' : 'Angka Ganjil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isEven ? Colors.blue.shade700 : Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 30),

              // Tombol +, -, dan Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrementCounter,
                    icon: const Icon(Icons.remove),
                    label: const Text('Kurang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}