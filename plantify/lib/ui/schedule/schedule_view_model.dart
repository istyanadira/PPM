import 'package:flutter/foundation.dart';

import '../../data/repositories/plant_schedule_repository.dart';
import '../../domain/models/plant_schedule.dart';

/// State halaman Jadwal: daftar jadwal dengan filter kategori
/// (dipakai oleh SegmentedButton).
class ScheduleViewModel extends ChangeNotifier {
  ScheduleViewModel({required this._scheduleRepository});

  final PlantScheduleRepository _scheduleRepository;

  bool _isLoading = false;
  String? _error;
  List<PlantSchedule> _schedules = const [];
  ScheduleCategory _selectedCategory = ScheduleCategory.watering;

  bool get isLoading => _isLoading;
  String? get error => _error;
  ScheduleCategory get selectedCategory => _selectedCategory;

  /// Jadwal yang sesuai dengan kategori terpilih.
  List<PlantSchedule> get schedules => _schedules
      .where((schedule) => schedule.category == _selectedCategory)
      .toList();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedules = await _scheduleRepository.getSchedules();
    } catch (e) {
      _error = 'Gagal memuat jadwal perawatan. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dipanggil saat pengguna mengganti segmen kategori.
  void selectCategory(ScheduleCategory category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    notifyListeners();
  }
}