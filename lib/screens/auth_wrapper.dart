import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniecommerceapp/providers/auth_provider.dart';
import 'package:miniecommerceapp/screens/home_screen.dart';
import 'package:miniecommerceapp/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show loading indicator while initializing
    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Return either Home or Login screen based on authentication status
    return authProvider.isAuthenticated
        ? const HomeScreen()
        : const LoginScreen();
  }
}
