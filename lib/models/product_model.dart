import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool inStock;
  final String? description;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.inStock,
    this.description,
    this.category,
  });

  // Factory constructor to create a Product from a JSON object
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  // Method to convert this Product instance to a JSON object
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Convenience constructor to create a Product from a Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      inStock: data['inStock'] as bool,
      description: data['description'] as String?,
      category: data['category'] as String?,
    );
  }
}
