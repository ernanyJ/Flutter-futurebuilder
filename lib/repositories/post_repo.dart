import 'dart:convert';

import 'package:future_testing/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepo {
  Future<Post> fetchPost(int id) async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    );

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON para um objeto Post
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao buscar post: ${response.statusCode}');
    }
  }
}
