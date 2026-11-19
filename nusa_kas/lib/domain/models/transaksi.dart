
enum JenisTransaksi {
  pemasukan,
  pengeluaran,
}

class Transaksi {
  final String id;
  final String keterangan;
  final double nominal;
  final JenisTransaksi jenis;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.keterangan,
    required this.nominal,
    required this.jenis,
    required this.tanggal,
  });

  // Mengubah data transaksi menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keterangan': keterangan,
      'nominal': nominal,
      'jenis': jenis.name,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  // Membuat objek transaksi dari Map
  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      keterangan: map['keterangan'],
      nominal: (map['nominal'] as num).toDouble(),
      jenis: JenisTransaksi.values.firstWhere(
        (item) => item.name == map['jenis'],
      ),
      tanggal: DateTime.parse(map['tanggal']),
    );
  }
}
