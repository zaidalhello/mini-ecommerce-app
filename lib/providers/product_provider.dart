import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniecommerceapp/models/product_model.dart';

enum ProductLoadStatus { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _products = [];
  ProductLoadStatus _status = ProductLoadStatus.initial;
  String? _errorMessage;

  // Getters to access the private properties
  List<Product> get products => _products;
  ProductLoadStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Initialize the provider by fetching products
  Future<void> fetchProducts() async {
    try {
      _status = ProductLoadStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Get products from Firestore
      final QuerySnapshot productSnapshot = await _firestore
          .collection('products')
          .get();

      // Convert the documents to Product objects
      _products = productSnapshot.docs.map((doc) {
        return Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      _status = ProductLoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = ProductLoadStatus.error;
      _errorMessage = 'Failed to load products: ${e.toString()}';
      notifyListeners();
    }
  }

  // Search products by name or category
  void searchProducts(String query) {
    // Implement search functionality in the future if needed
  }

  // Refresh products (useful for pull-to-refresh)
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  // Get a specific product by ID
  Product? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
