/// Kategori artikel pada Plantpedia.
enum InfoCategory {
  perawatan('Perawatan'),
  mediaTanam('Media Tanam'),
  pupuk('Pupuk'),
  masalah('Masalah Tanaman');

  const InfoCategory(this.label);

  /// Teks yang ditampilkan di UI.
  final String label;

  /// Mengubah teks dari JSON (misalnya "pupuk") menjadi enum.
  static InfoCategory fromName(String name) {
    return InfoCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => throw FormatException('Kategori info tidak dikenal: $name'),
    );
  }
}

/// Data informasi: artikel singkat tentang perawatan tanaman (Plantpedia).
class PlantInfo {
  const PlantInfo({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.content,
  });

  final String id;
  final String title;
  final InfoCategory category;
  final String description;
  final String content;

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      category: InfoCategory.fromName(json['category'] as String),
      description: json['description'] as String,
      content: json['content'] as String,
    );
  }
}