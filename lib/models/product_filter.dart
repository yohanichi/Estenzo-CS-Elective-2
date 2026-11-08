class ProductFilter {
  final String search;
  final int? categoryId;
  final double minPrice;
  final double maxPrice;
  final int page;
  final int pageSize;

  static const double defaultMinPrice = 0.0;
  static const double defaultMaxPrice = 10000.0;
  static const int defaultPageSize =
      8; // Activity requirement: 6-8 max per page

  const ProductFilter({
    this.search = '',
    this.categoryId,
    this.minPrice = defaultMinPrice,
    this.maxPrice = defaultMaxPrice,
    this.page = 1,
    this.pageSize = defaultPageSize,
  });

  bool get isPriceFiltered =>
      minPrice > defaultMinPrice || maxPrice < defaultMaxPrice;

  bool get isActive =>
      search.trim().isNotEmpty || categoryId != null || isPriceFiltered;

  ProductFilter copyWith({
    String? search,
    int? categoryId,
    bool clearCategory = false,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? pageSize,
  }) {
    return ProductFilter(
      search: search ?? this.search,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
