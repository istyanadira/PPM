import '../../domain/models/plant_info.dart';
import '../services/plantify_service.dart';

/// Mengelola data artikel Plantpedia (data informasi).
class PlantInfoRepository {
  PlantInfoRepository({required this._service});

  final PlantifyService _service;

  List<PlantInfo>? _cache;

  /// Mengambil semua artikel. Data diambil dari Service hanya sekali.
  Future<List<PlantInfo>> getPlantInfos() async {
    final cached = _cache;
    if (cached != null) return cached;

    final jsonList = await _service.fetchPlantInfos();
    _cache = List.unmodifiable(jsonList.map(PlantInfo.fromJson));
    return _cache!;
  }
}