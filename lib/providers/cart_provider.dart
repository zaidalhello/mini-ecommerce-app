import 'package:flutter/foundation.dart';
import 'package:miniecommerceapp/models/cart_item_model.dart';
import 'package:miniecommerceapp/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // List of cart items
  final List<CartItem> _items = [];

  // Get all items in cart
  List<CartItem> get cartItems => List.unmodifiable(_items);

  // Get total number of items in cart
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price of all items in cart
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Add product to cart
  void addProduct(Product product) {
    // Check if product already exists in cart
    int index = _findProductIndex(product);

    if (index != -1) {
      // Product exists, increase quantity
      _items[index].quantity += 1;
    } else {
      // Add new product to cart
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  // Remove product from cart
  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Update quantity of a product in cart
  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeProduct(product);
      return;
    }

    int index = _findProductIndex(product);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // Clear all items from cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Find index of a product in the cart
  int _findProductIndex(Product product) {
    return _items.indexWhere((item) => item.product.id == product.id);
  }
}
