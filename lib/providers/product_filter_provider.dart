import 'package:cs_elective_2/models/product_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productFilterProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilter>(
      ProductFilterNotifier.new,
    );

class ProductFilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() {
    return const ProductFilter();
  }

  void setPriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max, page: 1);
  }

  void setCategory(int? categoryId) {
    state = state.copyWith(
      categoryId: categoryId,
      clearCategory: categoryId == null,
      page: 1,
    );
  }

  void setSearch(String search) {
    state = state.copyWith(search: search, page: 1);
  }

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void prevPage() {
    if (state.page > 1) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void resetPriceRange() {
    state = state.copyWith(
      minPrice: ProductFilter.defaultMinPrice,
      maxPrice: ProductFilter.defaultMaxPrice,
      page: 1,
    );
  }

  void resetFilters() {
    state = const ProductFilter();
  }
}
