# NusaKas — Aplikasi Pencatatan Kas Himpunan

NusaKas merupakan aplikasi sederhana berbasis Flutter yang digunakan untuk mencatat pemasukan dan pengeluaran kas himpunan. Aplikasi ini membantu pengguna memantau saldo kas serta melihat riwayat transaksi secara praktis.

## Fitur Aplikasi

- Menampilkan total saldo kas.
- Menampilkan total pemasukan.
- Menampilkan total pengeluaran.
- Menambahkan transaksi pemasukan.
- Menambahkan transaksi pengeluaran.
- Menampilkan riwayat transaksi.
- Menghapus transaksi melalui fitur swipe.
- Validasi nominal transaksi agar tidak bernilai nol atau negatif.
- Validasi pengeluaran agar tidak melebihi saldo yang tersedia.

## Teknologi yang Digunakan

- Flutter
- Dart
- Material Design
- Flutter Test

## Struktur Folder

```text
lib/
├── main.dart
├── domain/
│   ├── kas_calculator.dart
│   └── models/
│       └── transaksi.dart
├── data/
│   └── repositories/
│       └── transaksi_repository.dart
└── ui/
    └── kas/
        ├── kas_view_model.dart
        ├── home_screen.dart
        └── tambah_transaksi_screen.dart

test/
├── unit/
│   └── kas_calculator_test.dart
├── widget/
│   ├── tambah_transaksi_screen_test.dart
│   └── widget_test.dart

integration_test/
└── app_test.dart
```

## Pengujian

Pengujian dilakukan menggunakan Flutter Test.

Hasil pengujian yang telah berhasil:

- 10 Unit Test
- 2 Widget Test
- 1 Widget Test bawaan aplikasi
- Flutter Analyze: No issues found

Total 13 test berhasil dijalankan.

**Catatan:** Integration test sudah disiapkan, tetapi belum berhasil dijalankan karena pengujian melalui Chrome belum didukung oleh perintah integration test yang digunakan.

## Screenshot Aplikasi

Screenshot aplikasi dapat dilihat pada folder `screenshots/`.

Dokumentasi yang disertakan:

1. Halaman utama NusaKas.
2. Halaman tambah transaksi.
3. Tampilan setelah pemasukan berhasil ditambahkan.
4. Validasi ketika pengeluaran melebihi saldo.
5. Tampilan setelah pengeluaran berhasil ditambahkan.
6. Riwayat transaksi.

## Cara Menjalankan Project

Pastikan Flutter sudah terpasang, kemudian jalankan perintah berikut:

```bash
git clone URL_REPOSITORY
cd nusa_kas
flutter pub get
flutter run -d chrome
```

## Cara Menjalankan Pengujian

Menjalankan seluruh unit dan widget test:

```bash
flutter test
```

Memeriksa kode:

```bash
flutter analyze
```

## Informasi Penyimpanan Data

Pada versi ini, data transaksi disimpan sementara menggunakan repository in-memory. Data transaksi akan kembali kosong ketika aplikasi dimulai ulang.

## Penutup

NusaKas dibuat sebagai proyek pembelajaran pengembangan aplikasi mobile menggunakan Flutter, dengan penerapan pemisahan struktur kode, pengelolaan transaksi, validasi input, serta pengujian aplikasi.