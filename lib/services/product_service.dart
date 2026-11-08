import 'package:cs_elective_2/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsResponse {
  final List<Product> products;
  final int totalCount;
  final int page;
  final int pageSize;

  ProductsResponse({
    required this.products,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => page * pageSize < totalCount;
  bool get hasPrevPage => page > 1;
}

class ProductService {
  // constructor that takes a SupabaseClient instance
  final SupabaseClient _client;
  ProductService(this._client);

  Future<ProductsResponse> fetchProducts({
    int page = 1,
    int pageSize = 8,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
    String? search,
  }) async {
    final from = (page - 1) * pageSize;
    final to = from + pageSize - 1;

    var countQuery = _client.from('products').count();
    if (minPrice != null) {
      countQuery = countQuery.gte('price', minPrice);
    }
    if (maxPrice != null) {
      countQuery = countQuery.lte('price', maxPrice);
    }
    if (categoryId != null) {
      countQuery = countQuery.eq('category_id', categoryId);
    }
    if (search != null && search.trim().isNotEmpty) {
      countQuery = countQuery.ilike('name', '%${search.trim()}%');
    }

    final int totalCount = await countQuery;

    var dataQuery = _client.from('products').select();
    if (minPrice != null) {
      dataQuery = dataQuery.gte('price', minPrice);
    }
    if (maxPrice != null) {
      dataQuery = dataQuery.lte('price', maxPrice);
    }
    if (categoryId != null) {
      dataQuery = dataQuery.eq('category_id', categoryId);
    }
    if (search != null && search.trim().isNotEmpty) {
      dataQuery = dataQuery.ilike('name', '%${search.trim()}%');
    }

    final data = await dataQuery
        .order('created_at', ascending: false)
        .range(from, to);

    final products = (data as List<dynamic>).map((item) {
      return Product(
        id: item['id'],
        name: item['name'],
        description: item['description'] ?? "N/A",
        price: double.tryParse(item['price']?.toString() ?? '') ?? 0.0,
        stock: item['stock'] ?? 0,
        categoryId: item['category_id'] ?? 0,
        imageUrl: item['image_url'] ?? "insert fallback url img",
      );
    }).toList();

    return ProductsResponse(
      products: products,
      totalCount: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<void> addProduct(Product product) async {
    await _client.from('products').insert({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'image_url': product.imageUrl,
      'category_id': product.categoryId,
    });
  }

  Future<void> deleteProduct(int id) async {
    final deleted = await _client
        .from('products')
        .delete()
        .eq('id', id)
        .select();

    if (deleted.isEmpty) {
      throw Exception('Product with id $id not found');
    }
  }

  Future<void> updateProduct(Product product) async {
    final updatedProds = await _client
        .from('products')
        .update({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'stock': product.stock,
          'image_url': product.imageUrl,
          'category_id': product.categoryId,
        })
        .eq('id', product.id)
        .select();

    if (updatedProds.isEmpty) {
      throw Exception(
        'Product with id ${product.id} not found or check table RLS.',
      );
    }
  }
}
