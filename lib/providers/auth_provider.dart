import 'package:flutter/material.dart';
import 'package:miniecommerceapp/models/user_model.dart';
import 'package:miniecommerceapp/services/auth_service.dart';
import 'package:miniecommerceapp/services/firestore_service.dart';
import 'package:miniecommerceapp/services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Initialize by checking current user
    _user = _authService.currentUser;

    // Listen to auth state changes
    _authService.user.listen((UserModel? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      UserModel? user = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      _setLoading(false);

      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Register with email, password, and additional user data
  Future<bool> register(
    String email,
    String password, {
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Use the new signUpAndCreateProfile method instead of registerWithEmailAndPassword
      UserModel? user = await _authService.signUpAndCreateProfile(
        email,
        password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      _setLoading(false);

      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle({String? fullName}) async {
    try {
      _setLoading(true);
      _clearError();

      // Start the Google sign-in flow
      final firebase_auth.UserCredential? userCredential =
          await _googleAuthService.signInWithGoogle();

      // Check if the user cancelled the sign-in
      if (userCredential == null || userCredential.user == null) {
        _setLoading(false);
        return false;
      }

      // Get the Firebase user
      final firebase_auth.User firebaseUser = userCredential.user!;

      // Create/update user in Firestore and get the UserModel
      UserModel? user = await _googleAuthService.createUserInFirestore(
        firebaseUser,
        fullName: fullName,
      );

      _setLoading(false);

      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // If the current user is signed in with Google, use the Google sign-out method
      if (_user != null && _user!.provider == 'google') {
        await _googleAuthService.signOut();
      } else {
        await _authService.signOut();
      }
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      // Update user data in Firestore
      await _firestoreService.updateUserData(uid, userData);

      // Refresh user data
      if (_user != null) {
        UserModel? updatedUser = await _firestoreService.getUserData(uid);
        if (updatedUser != null) {
          _user = updatedUser;
          notifyListeners();
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error updating profile: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Set loading state
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
