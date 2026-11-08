class ProductQuery {
  final String search;
  final int? categoryId;
  final bool lowStockOnly;

  const ProductQuery({
    this.search = '',
    this.categoryId,
    this.lowStockOnly = false,
  });

  // similar to JS spread operator, this allows you to create a new instance of ProductQuery with some properties changed while keeping the rest the same
  ProductQuery copyWith({
    String? search,
    int? categoryId,
    bool clearCategory = false, // use this to go back to "All"
    bool? lowStockOnly,
  }) {
    return ProductQuery(
      search: search ?? this.search,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
    );
  }
}
