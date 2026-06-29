class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final int stock;
  final String? category;
  final List<String> images;
  final double? rating;
  final int? reviewCount;
  final bool isWishlisted;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.stock,
    this.category,
    this.images = const [],
    this.rating,
    this.reviewCount,
    this.isWishlisted = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse images - could be a list or a single string
    List<String> parseImages() {
      final raw = json['images'] ?? json['image'] ?? json['photo'];
      if (raw == null) return [];
      if (raw is List) {
        return raw.map((e) => e.toString()).toList();
      }
      if (raw is String && raw.isNotEmpty) {
        return [raw];
      }
      return [];
    }

    return ProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']),
      originalPrice: json['original_price'] != null
          ? _parseDouble(json['original_price'])
          : null,
      discountPercent: json['discount_percent'] as int? ??
          json['discount'] as int?,
      stock: json['stock'] as int? ?? 0,
      category: json['category']?.toString(),
      images: parseImages(),
      rating: json['rating'] != null ? _parseDouble(json['rating']) : null,
      reviewCount: json['review_count'] as int? ?? json['reviews'] as int?,
      isWishlisted: json['is_wishlisted'] as bool? ?? false,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  String get thumbnail => images.isNotEmpty ? images.first : '';

  bool get hasDiscount =>
      discountPercent != null && discountPercent! > 0;

  bool get isInStock => stock > 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'images': images,
        'rating': rating,
      };

  ProductModel copyWith({
    bool? isWishlisted,
  }) {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      stock: stock,
      category: category,
      images: images,
      rating: rating,
      reviewCount: reviewCount,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  String toString() => 'ProductModel(id: $id, name: $name, price: $price)';
}
