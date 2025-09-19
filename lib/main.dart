import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniecommerceapp/firebase_config.dart';
import 'package:miniecommerceapp/providers/auth_provider.dart';
import 'package:miniecommerceapp/providers/cart_provider.dart';
import 'package:miniecommerceapp/providers/payment_provider.dart';
import 'package:miniecommerceapp/providers/product_provider.dart';
import 'package:miniecommerceapp/screens/auth_wrapper.dart';
import 'package:miniecommerceapp/screens/cart_screen.dart';
import 'package:miniecommerceapp/services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseConfig.initializeFirebase();
  
  // Initialize Stripe
 // await PaymentService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp(
        title: 'Mini E-commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}