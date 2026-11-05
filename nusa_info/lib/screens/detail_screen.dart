
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  final PostService service;

  const DetailScreen({
    super.key,
    required this.post,
    required this.service,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture =
        widget.service.fetchComments(widget.post.id);
  }

  final List<Map<String, String>> _bilingualComments = [
    {
      'name': 'Informasi Mahasiswa / Student Information',
      'body':
          'Terima kasih atas informasi yang telah diberikan. '
          'Mohon informasikan jika terdapat pembaruan lebih lanjut.\n\n'
          'Thank you for providing this information. '
          'Please let us know if there are any further updates.',
    },
    {
      'name': 'Pertanyaan Akademik / Academic Inquiry',
      'body':
          'Apakah informasi ini berlaku untuk seluruh mahasiswa? '
          'Mohon konfirmasi lebih lanjut.\n\n'
          'Does this information apply to all students? '
          'Please provide further confirmation.',
    },
    {
      'name': 'Tanggapan Mahasiswa / Student Feedback',
      'body':
          'Informasi ini sangat membantu mahasiswa. '
          'Semoga pengumuman seperti ini dapat terus diperbarui.\n\n'
          'This information is very helpful for students. '
          'We hope announcements like this will continue to be updated.',
    },
    {
      'name': 'Konfirmasi Jadwal / Schedule Confirmation',
      'body':
          'Mohon pastikan kembali jadwal dan ketentuan yang berlaku '
          'agar mahasiswa tidak melewatkan informasi penting.\n\n'
          'Please reconfirm the schedule and applicable requirements '
          'so students do not miss any important information.',
    },
    {
      'name': 'Apresiasi Mahasiswa / Student Appreciation',
      'body':
          'Terima kasih kepada pihak kampus atas informasi yang '
          'disampaikan. Kami akan mengikuti arahan yang diberikan.\n\n'
          'Thank you to the campus administration for sharing this '
          'information. We will follow the instructions provided.',
    },
  ];

  Map<String, dynamic> _createBilingualComment(int index) {
    final comment =
        _bilingualComments[index % _bilingualComments.length];

    return {
      'name': comment['name'],
      'email': 'mahasiswa${index + 1}@nusainfo.ac.id',
      'body': comment['body'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengumuman #${widget.post.id}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.post.body,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    Text(
                      'User ID: ${widget.post.userId}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Komentar / Comments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Gagal memuat komentar. '
                          'Periksa koneksi internet Anda.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _commentsFuture =
                                  widget.service.fetchComments(
                                widget.post.id,
                              );
                            });
                          },
                          child: const Text('Coba Lagi / Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final comments = snapshot.data ?? [];

                if (comments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Belum ada komentar / No comments yet.',
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment =
                        _createBilingualComment(index);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment['email']!,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    comment['body']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
