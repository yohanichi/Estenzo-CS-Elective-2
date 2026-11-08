import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/todo.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final res = await http.get(Uri.parse('$_baseUrl/posts?_limit=10'));
    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Post.fromJson(e)).toList();
  }

  Stream<List<Todo>> todoStream() async* {
    final collected = <Todo>[];
    for (var id = 1; id <= 15; id++) {
      await Future.delayed(const Duration(seconds: 2));
      final res = await http.get(Uri.parse('$_baseUrl/todos/$id'));
      if (res.statusCode != 200) {
        throw Exception('Server error ${res.statusCode}');
      }
      collected.add(Todo.fromJson(jsonDecode(res.body)));
      yield List.of(collected);
    }
  }
}
