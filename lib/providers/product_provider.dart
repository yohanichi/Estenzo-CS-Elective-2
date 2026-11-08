import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_filter_provider.dart';
import 'supabase_provider.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ref.watch(supabaseProvider));
});

final productProvider =
    AsyncNotifierProvider<ProductNotifier, ProductsResponse>(
      ProductNotifier.new,
    );

class ProductNotifier extends AsyncNotifier<ProductsResponse> {
  @override
  Future<ProductsResponse> build() {
    final filter = ref.watch(productFilterProvider);
    return ref
        .read(productServiceProvider)
        .fetchProducts(
          page: filter.page,
          pageSize: filter.pageSize,
          minPrice: filter.isPriceFiltered ? filter.minPrice : null,
          maxPrice: filter.isPriceFiltered ? filter.maxPrice : null,
          categoryId: filter.categoryId,
          search: filter.search,
        );
  }

  Future<void> addProduct(Product product) async {
    await ref.read(productServiceProvider).addProduct(product);
    ref.invalidateSelf();
    await future;
  }

  // Delete a product and refresh the current page
  Future<void> deleteProduct(int id) async {
    await ref.read(productServiceProvider).deleteProduct(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateProduct(Product product) async {
    await ref.read(productServiceProvider).updateProduct(product);
    ref.invalidateSelf();
    await future;
  }
}
