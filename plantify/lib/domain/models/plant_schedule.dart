/// Kategori aktivitas perawatan pada jadwal.
enum ScheduleCategory {
  watering('Penyiraman'),
  fertilizing('Pemupukan'),
  maintenance('Perawatan');

  const ScheduleCategory(this.label);

  /// Teks yang ditampilkan di UI.
  final String label;

  /// Mengubah teks dari JSON (misalnya "watering") menjadi enum.
  static ScheduleCategory fromName(String name) {
    return ScheduleCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => throw FormatException('Kategori jadwal tidak dikenal: $name'),
    );
  }
}

/// Data utama: jadwal aktivitas perawatan tanaman.
class PlantSchedule {
  const PlantSchedule({
    required this.id,
    required this.plantName,
    required this.activity,
    required this.category,
    required this.date,
    required this.description,
  });

  final String id;
  final String plantName;
  final String activity;
  final ScheduleCategory category;
  final DateTime date;
  final String description;

  factory PlantSchedule.fromJson(Map<String, dynamic> json) {
    return PlantSchedule(
      id: json['id'] as String,
      plantName: json['plantName'] as String,
      activity: json['activity'] as String,
      category: ScheduleCategory.fromName(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
    );
  }
}