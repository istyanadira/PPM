
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com';

  static const Duration timeout =
      Duration(seconds: 10);

  final http.Client client;

  PostService({http.Client? client})
      : client = client ?? http.Client();

  // GET: Mengambil semua pengumuman
  Future<List<Post>> fetchPosts() async {
    // 1. Buat alamat
    final url = Uri.parse('$baseUrl/posts');

    // 2. Kirim request
    final response =
        await client.get(url).timeout(timeout);

    // 3. Cek status code
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat pengumuman (${response.statusCode})',
      );
    }

    // 4. Ubah JSON menjadi objek
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((item) => Post.fromJson(item))
        .toList();
  }

  // GET: Mengambil komentar berdasarkan ID pengumuman
  Future<List<Map<String, dynamic>>> fetchComments(
      int postId) async {
    // 1. Buat alamat
    final url =
        Uri.parse('$baseUrl/posts/$postId/comments');

    // 2. Kirim request
    final response =
        await client.get(url).timeout(timeout);

    // 3. Cek status code
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat komentar');
    }

    // 4. Ubah JSON menjadi objek
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // POST: Membuat pengumuman baru
  Future<Post> createPost(Post post) async {
    // 1. Buat alamat
    final url = Uri.parse('$baseUrl/posts');

    // 2. Kirim request
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    ).timeout(timeout);

    // 3. Cek status code
    if (response.statusCode != 201) {
      throw Exception('Gagal membuat pengumuman');
    }

    // 4. Ubah JSON menjadi objek
    return Post.fromJson(jsonDecode(response.body));
  }

  void dispose() {
    client.close();
  }
}
