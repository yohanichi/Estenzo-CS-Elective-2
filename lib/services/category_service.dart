import 'package:cs_elective_2/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient _client;

  const CategoryService(this._client);

  Future<List<Category>> fetchAll() async {
    final data = await _client
        .from('categories')
        .select()
        .order('name', ascending: true);

    return (data as List<dynamic>).map((item) {
      return Category(
        id: item['id'],
        name: item['name'],
        createdAt: item['created_at'] != null
            ? DateTime.parse(item['created_at'])
            : null,
      );
    }).toList();
  }
}
