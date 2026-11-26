import '../../domain/models/plant_schedule.dart';
import '../services/plantify_service.dart';

/// Mengelola data jadwal perawatan (data utama).
class PlantScheduleRepository {
  PlantScheduleRepository({required this._service});

  final PlantifyService _service;

  List<PlantSchedule>? _cache;

  /// Mengambil semua jadwal. Data diambil dari Service hanya sekali,
  /// panggilan berikutnya memakai cache.
  Future<List<PlantSchedule>> getSchedules() async {
    final cached = _cache;
    if (cached != null) return cached;

    final jsonList = await _service.fetchSchedules();
    final schedules = jsonList.map(PlantSchedule.fromJson).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    _cache = List.unmodifiable(schedules);
    return _cache!;
  }

  /// Jadwal yang jatuh pada tanggal [date] (jam diabaikan).
  Future<List<PlantSchedule>> getSchedulesForDate(DateTime date) async {
    final schedules = await getSchedules();
    return schedules.where((s) => _isSameDay(s.date, date)).toList();
  }

  /// Jadwal dengan kategori tertentu.
  Future<List<PlantSchedule>> getSchedulesByCategory(
    ScheduleCategory category,
  ) async {
    final schedules = await getSchedules();
    return schedules.where((s) => s.category == category).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}