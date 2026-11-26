import 'package:flutter/foundation.dart';

import '../../domain/models/plant_task.dart';
import '../services/plantify_service.dart';

/// Mengelola data tugas perawatan (data aksi).
///
/// Repository ini adalah ChangeNotifier dan menjadi sumber data bersama
/// untuk Beranda, Checklist, dan badge pada tab Checklist. Setiap kali
/// status tugas berubah, semua pendengar diberi tahu lewat notifyListeners().
class PlantTaskRepository extends ChangeNotifier {
  PlantTaskRepository({required this._service});

  final PlantifyService _service;

  List<PlantTask> _tasks = const [];
  Future<void>? _loading;
  bool _loaded = false;

  /// Semua tugas (tidak bisa dimodifikasi dari luar).
  List<PlantTask> get tasks => List.unmodifiable(_tasks);

  /// Tugas yang belum selesai.
  List<PlantTask> get pendingTasks =>
      List.unmodifiable(_tasks.where((t) => !t.isCompleted));

  /// Tugas yang sudah selesai.
  List<PlantTask> get completedTasks =>
      List.unmodifiable(_tasks.where((t) => t.isCompleted));

  /// Jumlah tugas yang belum selesai (dipakai untuk badge tab Checklist).
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  /// Memuat tugas dari Service. Aman dipanggil berkali-kali dan dari
  /// beberapa tempat sekaligus: Service hanya dipanggil satu kali, sehingga
  /// centang yang sudah dilakukan tidak tertimpa data awal.
  Future<void> loadTasks() {
    if (_loaded) return Future.value();
    return _loading ??= _fetch();
  }

  Future<void> _fetch() async {
    try {
      final jsonList = await _service.fetchTasks();
      _tasks = jsonList.map(PlantTask.fromJson).toList();
      _loaded = true;
      notifyListeners();
    } finally {
      // Jika gagal, izinkan percobaan ulang pada pemanggilan berikutnya.
      _loading = null;
    }
  }

  /// Mengubah status selesai sebuah tugas (centang atau batal centang).
  void setTaskCompleted(String id, bool isCompleted) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    if (_tasks[index].isCompleted == isCompleted) return;

    final updated = List<PlantTask>.of(_tasks);
    updated[index] = updated[index].copyWith(isCompleted: isCompleted);
    _tasks = updated;
    notifyListeners();
  }

  /// Membalik status selesai sebuah tugas.
  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    setTaskCompleted(id, !_tasks[index].isCompleted);
  }
}