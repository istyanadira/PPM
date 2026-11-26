import 'package:flutter/foundation.dart';

import '../../data/repositories/plant_schedule_repository.dart';
import '../../data/repositories/plant_task_repository.dart';
import '../../domain/models/plant_schedule.dart';
import '../../domain/models/plant_task.dart';

/// State halaman Beranda. Menggabungkan data dari dua repository:
/// jadwal hari ini (PlantScheduleRepository) dan tugas yang belum
/// selesai (PlantTaskRepository).
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this._scheduleRepository,
    required this._taskRepository,
  }) {
    // Saat status tugas berubah, Beranda ikut diperbarui otomatis.
    _taskRepository.addListener(notifyListeners);
  }

  final PlantScheduleRepository _scheduleRepository;
  final PlantTaskRepository _taskRepository;

  bool _isLoading = false;
  String? _error;
  List<PlantSchedule> _todaySchedules = const [];
  DateTime _today = DateTime.now();

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Tanggal yang dianggap "hari ini" pada Beranda.
  DateTime get today => _today;

  /// Jadwal perawatan yang jatuh pada hari ini.
  List<PlantSchedule> get todaySchedules => _todaySchedules;

  /// Tugas yang belum selesai (diambil langsung dari repository bersama).
  List<PlantTask> get pendingTasks => _taskRepository.pendingTasks;

  /// Jumlah tugas yang sudah selesai dan total seluruh tugas.
  int get completedCount => _taskRepository.completedTasks.length;
  int get totalTaskCount => _taskRepository.tasks.length;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _today = DateTime.now();
      _todaySchedules = await _scheduleRepository.getSchedulesForDate(_today);
      await _taskRepository.loadTasks();
    } catch (e) {
      _error = 'Gagal memuat data beranda. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _taskRepository.removeListener(notifyListeners);
    super.dispose();
  }
}