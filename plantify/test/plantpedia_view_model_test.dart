import 'package:flutter_test/flutter_test.dart';
import 'package:plantify/data/repositories/plant_info_repository.dart';
import 'package:plantify/domain/models/plant_info.dart';
import 'package:plantify/ui/plantpedia/plantpedia_view_model.dart';

/// Repository palsu untuk pengujian: tanpa Service dan tanpa delay.
class FakePlantInfoRepository implements PlantInfoRepository {
  FakePlantInfoRepository({this.infos = const [], this.shouldFail = false});

  final List<PlantInfo> infos;
  final bool shouldFail;

  @override
  Future<List<PlantInfo>> getPlantInfos() async {
    if (shouldFail) throw Exception('Gagal memuat data');
    return infos;
  }
}

const _sampleInfos = [
  PlantInfo(
    id: 'i1',
    title: 'Cara Merawat Monstera',
    category: InfoCategory.perawatan,
    description: 'Panduan Monstera.',
    content: 'Isi artikel Monstera.',
  ),
  PlantInfo(
    id: 'i2',
    title: 'Manfaat Pupuk Organik',
    category: InfoCategory.pupuk,
    description: 'Tentang pupuk organik.',
    content: 'Isi artikel pupuk organik.',
  ),
  PlantInfo(
    id: 'i3',
    title: 'Pupuk Cair atau Padat?',
    category: InfoCategory.pupuk,
    description: 'Perbedaan pupuk.',
    content: 'Isi artikel pupuk cair.',
  ),
  PlantInfo(
    id: 'i4',
    title: 'Tips Memilih Media Tanam',
    category: InfoCategory.mediaTanam,
    description: 'Media tanam.',
    content: 'Isi artikel media tanam.',
  ),
];

void main() {
  PlantpediaViewModel buildViewModel({bool shouldFail = false}) {
    return PlantpediaViewModel(
      infoRepository: FakePlantInfoRepository(
        infos: _sampleInfos,
        shouldFail: shouldFail,
      ),
    );
  }

  group('PlantpediaViewModel', () {
    test('initial state: belum loading, tanpa error, daftar kosong', () {
      final viewModel = buildViewModel();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.infos, isEmpty);
      expect(viewModel.query, '');
      expect(viewModel.selectedCategory, isNull);
    });

    test('isLoading true selama load() berjalan', () async {
      final viewModel = buildViewModel();

      final future = viewModel.load();
      expect(viewModel.isLoading, true);

      await future;
      expect(viewModel.isLoading, false);
    });

    test('load() berhasil memuat semua artikel', () async {
      final viewModel = buildViewModel();

      await viewModel.load();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.infos.length, 4);
    });

    test('search() menyaring berdasarkan judul tanpa peka huruf besar', () async {
      final viewModel = buildViewModel();
      await viewModel.load();

      viewModel.search('PUPUK');

      expect(viewModel.infos.length, 2);
      expect(
        viewModel.infos.map((info) => info.id),
        containsAll(['i2', 'i3']),
      );
    });

    test('search() tanpa hasil menghasilkan daftar kosong', () async {
      final viewModel = buildViewModel();
      await viewModel.load();

      viewModel.search('zzz');

      expect(viewModel.infos, isEmpty);
    });

    test('selectCategory() menyaring kategori, null menampilkan semua',
        () async {
      final viewModel = buildViewModel();
      await viewModel.load();

      viewModel.selectCategory(InfoCategory.pupuk);
      expect(viewModel.infos.length, 2);
      expect(
        viewModel.infos.every((info) => info.category == InfoCategory.pupuk),
        true,
      );

      viewModel.selectCategory(null);
      expect(viewModel.infos.length, 4);
    });

    test('search() dan filter kategori bekerja bersamaan', () async {
      final viewModel = buildViewModel();
      await viewModel.load();

      viewModel.selectCategory(InfoCategory.pupuk);
      viewModel.search('organik');

      expect(viewModel.infos.length, 1);
      expect(viewModel.infos.first.id, 'i2');
    });

    test('load() gagal mengisi error dan daftar tetap kosong', () async {
      final viewModel = buildViewModel(shouldFail: true);

      await viewModel.load();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNotNull);
      expect(viewModel.infos, isEmpty);
    });
  });
}