// providers/category_provider.dart
import 'package:cs_elective_2/models/category.dart';
import 'package:cs_elective_2/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'supabase_provider.dart';

// exposes the service (dependency injection)
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService(ref.watch(supabaseProvider));
});

// exposes the state (loading / error / data)
final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryServiceProvider).fetchAll();
});
