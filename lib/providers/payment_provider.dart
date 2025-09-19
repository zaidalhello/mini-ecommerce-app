import 'package:flutter/foundation.dart';
import 'package:miniecommerceapp/models/cart_item_model.dart';
import 'package:miniecommerceapp/services/payment_service.dart';

enum PaymentStatus { initial, loading, success, failed }

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  PaymentStatus _status = PaymentStatus.initial;
  String _errorMessage = '';
  String _paymentId = '';

  // Getters
  PaymentStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get paymentId => _paymentId;
  bool get isLoading => _status == PaymentStatus.loading;
  bool get isSuccess => _status == PaymentStatus.success;
  bool get isFailed => _status == PaymentStatus.failed;

  // Reset payment state
  void resetPayment() {
    _status = PaymentStatus.initial;
    _errorMessage = '';
    _paymentId = '';
    notifyListeners();
  }

  // Process payment
  Future<bool> processPayment({
    required double amount,
    required String currency,
    required List<CartItem> items,
    required context,
  }) async {
    try {
      // Update state to loading
      _status = PaymentStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // Call payment service to process payment
      final result = await _paymentService.processPayment(
        amount: amount,
        currency: currency,
        context: context,
        items: items,
      );

      // Handle payment result
      if (result['success'] == true) {
        _status = PaymentStatus.success;
        _paymentId = result['paymentId'] ?? '';
        notifyListeners();
        return true;
      } else {
        _status = PaymentStatus.failed;
        _errorMessage = result['message'] ?? 'Payment failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PaymentStatus.failed;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Optional: Verify payment status with backend
  Future<bool> verifyPayment() async {
    if (_paymentId.isEmpty) {
      _status = PaymentStatus.failed;
      _errorMessage = 'No payment to verify';
      notifyListeners();
      return false;
    }

    try {
      final isVerified = await _paymentService.verifyPayment(_paymentId);

      if (isVerified) {
        _status = PaymentStatus.success;
      } else {
        _status = PaymentStatus.failed;
        _errorMessage = 'Payment verification failed';
      }

      notifyListeners();
      return isVerified;
    } catch (e) {
      _status = PaymentStatus.failed;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
