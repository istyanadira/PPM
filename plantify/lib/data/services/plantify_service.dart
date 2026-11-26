/// Service yang mensimulasikan server: menyediakan data contoh dalam
/// bentuk JSON (Map) secara asynchronous memakai Future.delayed().
///
/// Service tidak mengenal model, repository, atau UI.
class PlantifyService {
  const PlantifyService({
    this.delay = const Duration(milliseconds: 800),
  });

  /// Lama simulasi respons server.
  final Duration delay;

  /// Mengubah tanggal menjadi teks ISO 8601 (contoh: "2026-11-26").
  /// [daysFromToday] = 0 berarti hari ini, 1 berarti besok, -1 kemarin.
  String _isoDate(int daysFromToday) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day + daysFromToday);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  /// Data utama: jadwal perawatan tanaman.
  Future<List<Map<String, dynamic>>> fetchSchedules() async {
    await Future.delayed(delay);
    return [
      {
        'id': 's1',
        'plantName': 'Monstera',
        'activity': 'Penyiraman Monstera',
        'category': 'watering',
        'date': _isoDate(0),
        'description':
            'Siram hingga air keluar dari lubang pot, lalu buang air di tatakan.',
      },
      {
        'id': 's2',
        'plantName': 'Lidah Mertua',
        'activity': 'Pemupukan Lidah Mertua',
        'category': 'fertilizing',
        'date': _isoDate(0),
        'description':
            'Beri pupuk cair encer. Cukup sebulan sekali agar akar tidak busuk.',
      },
      {
        'id': 's3',
        'plantName': 'Calathea',
        'activity': 'Pembersihan daun Calathea',
        'category': 'maintenance',
        'date': _isoDate(0),
        'description':
            'Lap daun dengan kain lembap untuk membuang debu dan membantu fotosintesis.',
      },
      {
        'id': 's4',
        'plantName': 'Peace Lily',
        'activity': 'Penyiraman Peace Lily',
        'category': 'watering',
        'date': _isoDate(1),
        'description':
            'Jaga tanah tetap lembap tetapi tidak becek. Siram saat permukaan tanah mulai kering.',
      },
      {
        'id': 's5',
        'plantName': 'Sirih Gading',
        'activity': 'Pemangkasan Sirih Gading',
        'category': 'maintenance',
        'date': _isoDate(2),
        'description':
            'Pangkas sulur yang terlalu panjang atau daun menguning agar tumbuh lebih rimbun.',
      },
      {
        'id': 's6',
        'plantName': 'Monstera',
        'activity': 'Pemupukan Monstera',
        'category': 'fertilizing',
        'date': _isoDate(3),
        'description':
            'Gunakan pupuk organik cair untuk mendukung pertumbuhan daun baru.',
      },
    ];
  }

  /// Data aksi: daftar tugas perawatan yang bisa dicentang.
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    await Future.delayed(delay);
    return [
      {
        'id': 't1',
        'title': 'Menyiram tanaman Monstera',
        'plantName': 'Monstera',
        'description': 'Siram pagi hari dengan air secukupnya.',
        'isCompleted': false,
      },
      {
        'id': 't2',
        'title': 'Membersihkan daun tanaman',
        'plantName': 'Calathea',
        'description': 'Lap kedua sisi daun dengan kain lembap.',
        'isCompleted': false,
      },
      {
        'id': 't3',
        'title': 'Mengganti air vas bunga',
        'plantName': 'Sirih Gading',
        'description': 'Ganti air agar tidak berlumut dan berbau.',
        'isCompleted': false,
      },
      {
        'id': 't4',
        'title': 'Memberikan pupuk organik',
        'plantName': 'Lidah Mertua',
        'description': 'Taburkan pupuk kompos tipis di sekitar pangkal tanaman.',
        'isCompleted': false,
      },
      {
        'id': 't5',
        'title': 'Memeriksa kondisi tanah',
        'plantName': 'Peace Lily',
        'description': 'Tekan tanah dengan jari, siram jika terasa kering.',
        'isCompleted': true,
      },
      {
        'id': 't6',
        'title': 'Memutar posisi pot',
        'plantName': 'Monstera',
        'description': 'Putar pot seperempat putaran agar tumbuh merata.',
        'isCompleted': true,
      },
    ];
  }

  /// Data informasi: artikel singkat untuk Plantpedia.
  Future<List<Map<String, dynamic>>> fetchPlantInfos() async {
    await Future.delayed(delay);
    return [
      {
        'id': 'i1',
        'title': 'Cara Merawat Monstera',
        'category': 'perawatan',
        'description':
            'Panduan singkat cahaya, air, dan kelembapan untuk Monstera.',
        'content':
            'Monstera menyukai cahaya terang tidak langsung. Hindari sinar matahari yang menyengat karena dapat membuat daun terbakar.\n\n'
                'Siram ketika 2-3 cm tanah bagian atas sudah kering. Pastikan pot memiliki lubang drainase agar akar tidak terendam.\n\n'
                'Bersihkan daun secara berkala dan beri tiang rambat agar tanaman tumbuh tegak dengan daun berlubang yang indah.',
      },
      {
        'id': 'i2',
        'title': 'Tips Memilih Media Tanam',
        'category': 'mediaTanam',
        'description':
            'Kenali campuran media tanam yang cocok untuk tanaman hias.',
        'content':
            'Media tanam yang baik harus gembur, mampu menyimpan sedikit air, dan memiliki drainase yang lancar.\n\n'
                'Campuran umum untuk tanaman hias adalah tanah, kompos, dan sekam bakar dengan perbandingan seimbang.\n\n'
                'Untuk tanaman yang tidak suka basah seperti lidah mertua, tambahkan pasir atau perlit agar air cepat mengalir.',
      },
      {
        'id': 'i3',
        'title': 'Mengenali Tanaman yang Kekurangan Air',
        'category': 'masalah',
        'description':
            'Tanda-tanda tanaman kurang air dan cara menolongnya.',
        'content':
            'Tanda umum tanaman kekurangan air adalah daun layu, ujung daun mengering, dan tanah yang keras serta menjauh dari tepi pot.\n\n'
                'Siram perlahan hingga air keluar dari lubang drainase. Jangan menyiram berlebihan sekaligus karena tanah kering sulit menyerap air.\n\n'
                'Periksa kelembapan tanah dengan jari sebelum menyiram agar tidak terbalik menjadi kelebihan air.',
      },
      {
        'id': 'i4',
        'title': 'Manfaat Pupuk Organik',
        'category': 'pupuk',
        'description':
            'Mengapa pupuk organik baik untuk tanaman dan tanah.',
        'content':
            'Pupuk organik berasal dari bahan alami seperti kompos, kotoran hewan, dan sisa tumbuhan. Pupuk ini memperbaiki struktur tanah sekaligus memberi nutrisi secara bertahap.\n\n'
                'Dibandingkan pupuk kimia, pupuk organik lebih kecil risikonya membuat akar terbakar.\n\n'
                'Gunakan secukupnya, kira-kira sebulan sekali untuk tanaman hias dalam ruangan.',
      },
      {
        'id': 'i5',
        'title': 'Tips Merawat Tanaman Indoor',
        'category': 'perawatan',
        'description':
            'Cara menjaga tanaman tetap sehat di dalam ruangan.',
        'content':
            'Letakkan tanaman dekat jendela yang mendapat cahaya terang. Putar pot secara berkala agar semua sisi mendapat cahaya.\n\n'
                'Hindari menaruh tanaman tepat di depan AC atau kipas karena udara dingin dan kering dapat merusak daun.\n\n'
                'Sesuaikan penyiraman dengan kondisi ruangan, karena ruangan yang sejuk membuat tanah lebih lama kering.',
      },
      {
        'id': 'i6',
        'title': 'Pupuk Cair atau Padat?',
        'category': 'pupuk',
        'description':
            'Perbedaan pupuk cair dan padat dan kapan memakainya.',
        'content':
            'Pupuk cair cepat diserap akar dan cocok untuk tanaman yang butuh nutrisi segera. Pupuk padat bekerja lebih lambat tetapi efeknya bertahan lama.\n\n'
                'Untuk pemula, pupuk cair yang diencerkan lebih mudah diatur takarannya.\n\n'
                'Selalu ikuti petunjuk kemasan dan hindari memupuk tanaman yang sedang stres atau tanahnya sangat kering.',
      },
    ];
  }
}