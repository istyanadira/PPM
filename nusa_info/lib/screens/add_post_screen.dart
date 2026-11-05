import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class AddPostScreen extends StatefulWidget {
  final PostService service;

  const AddPostScreen({
    super.key,
    required this.service,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _bodyController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _submitPost() async {
    // Memeriksa validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newPost = Post(
        id: 0,
        userId: 1,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      // Mengirim data ke API menggunakan POST
      final createdPost =
          await widget.service.createPost(newPost);

      if (!mounted) return;

      // Mengirim hasil kembali ke Home Screen
      Navigator.pop(context, createdPost);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan pengumuman: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengumuman'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buat Pengumuman Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Isi informasi yang ingin kamu sampaikan.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              const Text(
                'Judul Pengumuman',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul pengumuman',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }

                  if (value.trim().length < 5) {
                    return 'Judul minimal 5 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Isi Pengumuman',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _bodyController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan isi pengumuman...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi pengumuman tidak boleh kosong';
                  }

                  if (value.trim().length < 10) {
                    return 'Isi minimal 10 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitPost,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _isLoading
                        ? 'Mengirim...'
                        : 'Kirim Pengumuman',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}