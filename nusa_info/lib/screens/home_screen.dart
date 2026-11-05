
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import 'detail_screen.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _service = PostService();

  late Future<List<Post>> _postsFuture;

  // Menyimpan pengumuman baru yang ditambahkan pengguna
  final List<Post> _newPosts = [];

  // 10 kategori pengumuman kampus
  final List<Map<String, String>> _categories = [
    {
      'title': 'Jadwal Perkuliahan / Class Schedule',
      'topic': 'jadwal perkuliahan',
      'englishTopic': 'class schedule',
    },
    {
      'title': 'Kegiatan Kampus / Campus Activities',
      'topic': 'kegiatan kampus',
      'englishTopic': 'campus activities',
    },
    {
      'title': 'Informasi Akademik / Academic Information',
      'topic': 'informasi akademik',
      'englishTopic': 'academic information',
    },
    {
      'title': 'Informasi Beasiswa / Scholarship Information',
      'topic': 'program beasiswa',
      'englishTopic': 'scholarship programs',
    },
    {
      'title': 'Jadwal Ujian / Examination Schedule',
      'topic': 'jadwal ujian',
      'englishTopic': 'examination schedule',
    },
    {
      'title': 'Seminar Mahasiswa / Student Seminar',
      'topic': 'seminar mahasiswa',
      'englishTopic': 'student seminars',
    },
    {
      'title': 'Informasi Pembayaran / Payment Information',
      'topic': 'pembayaran administrasi',
      'englishTopic': 'administrative payments',
    },
    {
      'title': 'Pengumpulan Tugas / Assignment Submission',
      'topic': 'pengumpulan tugas',
      'englishTopic': 'assignment submission',
    },
    {
      'title': 'Informasi Wisuda / Graduation Information',
      'topic': 'pelaksanaan wisuda',
      'englishTopic': 'graduation ceremony',
    },
    {
      'title': 'Fasilitas Kampus / Campus Facilities',
      'topic': 'fasilitas kampus',
      'englishTopic': 'campus facilities',
    },
  ];

  // 10 variasi isi pengumuman bilingual
  final List<String> _bodyTemplates = [
    'Informasi lebih lanjut mengenai {topic} dapat diperoleh '
        'melalui bagian administrasi kampus. '
        'For more information about {englishTopic}, '
        'please contact the campus administration office.',

    'Seluruh mahasiswa diharapkan memperhatikan informasi '
        'terbaru mengenai {topic}. '
        'All students are encouraged to stay updated '
        'on the latest information about {englishTopic}.',

    'Mahasiswa diminta untuk memeriksa pengumuman resmi '
        'terkait {topic} secara berkala. '
        'Students are advised to regularly check official '
        'announcements regarding {englishTopic}.',

    'Informasi ini ditujukan kepada seluruh mahasiswa '
        'agar tidak melewatkan informasi penting mengenai {topic}. '
        'This announcement is intended for all students '
        'to keep them informed about {englishTopic}.',

    'Silakan menghubungi pihak kampus apabila membutuhkan '
        'informasi tambahan mengenai {topic}. '
        'Please contact the campus office if you need '
        'additional information about {englishTopic}.',

    'Pastikan seluruh persyaratan dan ketentuan mengenai '
        '{topic} telah diperhatikan. '
        'Please make sure that all requirements and guidelines '
        'regarding {englishTopic} are understood.',

    'Mahasiswa diharapkan mengikuti informasi dan arahan '
        'resmi dari pihak kampus mengenai {topic}. '
        'Students are expected to follow official campus '
        'updates and instructions about {englishTopic}.',

    'Mohon perhatikan jadwal dan ketentuan yang berlaku '
        'terkait {topic}. '
        'Please pay attention to the applicable schedule '
        'and regulations concerning {englishTopic}.',

    'Pengumuman ini disampaikan agar seluruh mahasiswa '
        'dapat mempersiapkan diri terkait {topic}. '
        'This announcement is provided to help all students '
        'prepare for {englishTopic}.',

    'Terima kasih atas perhatian dan kerja sama seluruh '
        'mahasiswa dalam mengikuti informasi mengenai {topic}. '
        'Thank you for your attention and cooperation '
        'in following updates about {englishTopic}.',
  ];

  @override
  void initState() {
    super.initState();

    // Mengambil seluruh 100 pengumuman dari API
    _postsFuture = _service.fetchPosts();
  }

  // Mengubah data API menjadi pengumuman bilingual
  Post _createBilingualPost(Post originalPost) {
    final categoryIndex = (originalPost.id - 1) % 10;

    final templateIndex = (originalPost.id - 1) ~/ 10;

    final category = _categories[categoryIndex];

    final template = _bodyTemplates[templateIndex];

    final body = template
        .replaceAll('{topic}', category['topic']!)
        .replaceAll('{englishTopic}', category['englishTopic']!);

    return Post(
      id: originalPost.id,
      userId: originalPost.userId,
      title:
          '${category['title']} — Pengumuman #${originalPost.id}',
      body: body,
    );
  }

  // Memuat ulang daftar pengumuman
  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _service.fetchPosts();
    });

    try {
      await _postsFuture;
    } catch (_) {
      // Error ditangani oleh FutureBuilder
    }
  }

  // Membuka halaman tambah pengumuman
  Future<void> _openAddPost() async {
    final createdPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostScreen(
          service: _service,
        ),
      ),
    );

    if (!mounted) return;

    if (createdPost != null) {
      setState(() {
        _newPosts.insert(0, createdPost);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pengumuman berhasil ditambahkan!',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NusaInfo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _openAddPost,
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Pengumuman',
          ),
        ],
      ),

      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {

          // Tampilan loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Tampilan error
          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 150),
                  const Icon(
                    Icons.wifi_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Gagal memuat pengumuman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Periksa koneksi internet kamu.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _refreshPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Mengambil seluruh data dari API
          final posts = snapshot.data ?? [];

          // Mengubah semua data API menjadi bilingual
          final translatedPosts = posts
              .map((post) => _createBilingualPost(post))
              .toList();

          // Menggabungkan pengumuman baru dan API
          final allPosts = [
            ..._newPosts,
            ...translatedPosts,
          ];

          // Jika data kosong
          if (allPosts.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      'Belum ada pengumuman.',
                    ),
                  ),
                ],
              ),
            );
          }

          // Menampilkan semua pengumuman
          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: allPosts.length,

              itemBuilder: (context, index) {
                final post = allPosts[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(16),

                    // Nomor pengumuman
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        '${post.id}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Judul bilingual
                    title: Text(
                      post.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Isi bilingual
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: 8),
                      child: Text(
                        post.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    // Membuka halaman detail
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            post: post,
                            service: _service,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
