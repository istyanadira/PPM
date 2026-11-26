import 'package:flutter/foundation.dart';

import '../../data/repositories/plant_task_repository.dart';
import '../../domain/models/plant_task.dart';

/// State halaman Checklist: tugas dibagi menjadi "Belum Selesai"
/// dan "Sudah Selesai". Sumber datanya adalah PlantTaskRepository
/// yang sama dengan yang dipakai Beranda.
class ChecklistViewModel extends ChangeNotifier {
  ChecklistViewModel({required this._taskRepository}) {
    // Teruskan perubahan dari repository ke View.
    _taskRepository.addListener(notifyListeners);
  }

  final PlantTaskRepository _taskRepository;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<PlantTask> get pendingTasks => _taskRepository.pendingTasks;
  List<PlantTask> get completedTasks => _taskRepository.completedTasks;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _taskRepository.loadTasks();
    } catch (e) {
      _error = 'Gagal memuat checklist. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dipanggil saat pengguna mencentang atau membatalkan centang.
  void setTaskCompleted(String id, bool isCompleted) {
    _taskRepository.setTaskCompleted(id, isCompleted);
  }

  @override
  void dispose() {
    _taskRepository.removeListener(notifyListeners);
    super.dispose();
  }
}