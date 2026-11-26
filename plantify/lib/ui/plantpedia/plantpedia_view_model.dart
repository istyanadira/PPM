import 'package:flutter/foundation.dart';

import '../../data/repositories/plant_info_repository.dart';
import '../../domain/models/plant_info.dart';

/// State halaman Plantpedia: daftar artikel dengan pencarian judul
/// dan filter kategori.
class PlantpediaViewModel extends ChangeNotifier {
  PlantpediaViewModel({required this._infoRepository});

  final PlantInfoRepository _infoRepository;

  bool _isLoading = false;
  String? _error;
  List<PlantInfo> _allInfos = const [];
  String _query = '';
  InfoCategory? _selectedCategory; // null = semua kategori

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;
  InfoCategory? get selectedCategory => _selectedCategory;

  /// Artikel hasil pencarian dan filter.
  List<PlantInfo> get infos {
    final keyword = _query.trim().toLowerCase();

    return _allInfos.where((info) {
      final matchesCategory =
          _selectedCategory == null || info.category == _selectedCategory;
      final matchesQuery =
          keyword.isEmpty || info.title.toLowerCase().contains(keyword);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allInfos = await _infoRepository.getPlantInfos();
    } catch (e) {
      _error = 'Gagal memuat artikel Plantpedia. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dipanggil saat pengguna mengetik di kolom pencarian.
  void search(String query) {
    _query = query;
    notifyListeners();
  }

  /// Dipilih null untuk menampilkan semua kategori.
  void selectCategory(InfoCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}