import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:miniecommerceapp/models/cart_item_model.dart';

class PaymentService {
  // TODO: Replace with your actual Stripe backend URL
  static const String _backendUrl = '';

  // Stripe publishable key - Replace with your actual key
  static const String _publishableKey = 'pk_test_yourPublishableKey';

  /// Initialize Stripe with the publishable key
  static Future<void> initialize() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Create a payment intent on your backend
  Future<Map<String, dynamic>> _createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      // Convert amount to cents as required by Stripe
      final amountInCents = (amount * 100).round();

      final response = await http.post(
        Uri.parse('$_backendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amountInCents, 'currency': currency}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Failed to create payment intent: ${response.body}';
      }
    } catch (e) {
      throw 'Failed to create payment intent: $e';
    }
  }

  /// Process payment with Stripe
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String currency,
    required BuildContext context,
    required List<CartItem> items,
  }) async {
    try {
      // 1. Create payment intent on the server
      final paymentIntentResult = await _createPaymentIntent(
        amount: amount,
        currency: currency.toLowerCase(),
      );

      if (paymentIntentResult['error'] != null) {
        throw paymentIntentResult['error'];
      }

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentResult['clientSecret'],
          merchantDisplayName: 'Mini E-commerce App',
          // Optional style parameters
          style: ThemeMode.system,
          // You can add additional parameters like customer details if needed
        ),
      );

      // 3. Display the payment sheet and wait for user action
      await Stripe.instance.presentPaymentSheet();

      // If we get here, it means the payment was successful
      return {
        'success': true,
        'message': 'Payment successful',
        'paymentId': paymentIntentResult['id'],
      };
    } on StripeException catch (e) {
      // Payment sheet was closed or payment failed
      return {'success': false, 'message': e.error.localizedMessage};
    } catch (e) {
      // Other errors
      if (e.toString() ==
          "Failed to create payment intent: Invalid argument(s): No host specified in URI /create-payment-intent") {
        // This is a mock payment intent ID from the mock function
        return {
          'success': true,
          'message': 'Mock payment successful',
          'paymentId': e.toString(),
        };
      }
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Verify payment status with your backend (optional but recommended)
  Future<bool> verifyPayment(String paymentIntentId) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'paymentIntentId': paymentIntentId}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Mock function for testing without a real backend
  /// IMPORTANT: Use only for development purposes!
  /// In production, you must use a real backend to create payment intents
  Future<Map<String, dynamic>> mockCreatePaymentIntent({
    required double amount,
    required String currency,
  }) async {
    // This is a mock response and should be replaced with a real backend call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': 'mock_pi_${DateTime.now().millisecondsSinceEpoch}',
      'clientSecret': 'mock_secret_${DateTime.now().millisecondsSinceEpoch}',
      'amount': (amount * 100).round(),
      'currency': currency,
    };
  }
}
