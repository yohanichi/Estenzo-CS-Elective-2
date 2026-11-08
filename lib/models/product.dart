class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.categoryId,
  });

  // This method allows you to create a new instance of Product with some properties changed while keeping the rest the same
  Product copyWith({
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    int? categoryId,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
