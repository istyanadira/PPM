/// Data aksi: aktivitas perawatan yang bisa dicentang sebagai selesai.
class PlantTask {
  const PlantTask({
    required this.id,
    required this.title,
    required this.plantName,
    required this.description,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String plantName;
  final String description;
  final bool isCompleted;

  factory PlantTask.fromJson(Map<String, dynamic> json) {
    return PlantTask(
      id: json['id'] as String,
      title: json['title'] as String,
      plantName: json['plantName'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  /// Membuat salinan dengan sebagian field diganti.
  /// Dipakai untuk mengubah status centang tanpa mengubah objek lama,
  /// karena semua field bersifat final.
  PlantTask copyWith({
    String? id,
    String? title,
    String? plantName,
    String? description,
    bool? isCompleted,
  }) {
    return PlantTask(
      id: id ?? this.id,
      title: title ?? this.title,
      plantName: plantName ?? this.plantName,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}