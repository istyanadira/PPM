import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/plant_info_repository.dart';
import '../data/repositories/plant_schedule_repository.dart';
import '../data/repositories/plant_task_repository.dart';
import '../data/services/plantify_service.dart';

/// Daftar semua dependency aplikasi (Service dan Repository).
///
/// Urutan penting: Service harus didaftarkan lebih dulu karena dipakai
/// oleh semua Repository lewat context.read().
List<SingleChildWidget> get providers {
  return [
    // Service: lapisan paling bawah.
    Provider<PlantifyService>(
      create: (_) => const PlantifyService(),
    ),

    // Repository: satu instance dipakai bersama oleh semua halaman.
    Provider<PlantScheduleRepository>(
      create: (context) => PlantScheduleRepository(
        service: context.read<PlantifyService>(),
      ),
    ),
    ChangeNotifierProvider<PlantTaskRepository>(
      create: (context) => PlantTaskRepository(
        service: context.read<PlantifyService>(),
      ),
    ),
    Provider<PlantInfoRepository>(
      create: (context) => PlantInfoRepository(
        service: context.read<PlantifyService>(),
      ),
    ),
  ];
}