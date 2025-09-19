import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniecommerceapp/models/user_model.dart';
import 'package:miniecommerceapp/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Create user object based on FirebaseUser
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  // Auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Get current user
  UserModel? get currentUser {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  // Get current user with additional data from Firestore
  Future<UserModel?> getCurrentUserWithData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Get additional data from Firestore
      UserModel? userModel = await _firestoreService.getUserData(user.uid);
      return userModel;
    }
    return null;
  }

  // Sign in with email & password
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? 'Error signing in');
      return null;
    } catch (e) {
      _showToast('An unexpected error occurred');
      return null;
    }
  }

  // DEPRECATED: Use signUpAndCreateProfile instead
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password, {
    String? fullName,
    String? phoneNumber,
  }) async {
    return signUpAndCreateProfile(
      email,
      password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }

  // New function that handles sign up and profile creation in a single transaction
  Future<UserModel?> signUpAndCreateProfile(
    String email,
    String password, {
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      // Step 1: Create the user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Wait for the user object and fall back to currentUser if needed
      User? user = result.user;
      if (user == null) {
        user = _auth.currentUser;
        if (user == null) {
          throw Exception('Failed to retrieve authenticated user');
        }
      }

      // Step 3: Create a user model with profile data
      Map<String, dynamic> userData = {
        'uid': user.uid, // Ensure user ID matches auth UID
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      };

      // Create the user model
      UserModel userModel = UserModel.fromFirestore(userData);

      // Step 4: Save the user data to Firestore under the exact same UID
      await _firestoreService.saveUserData(userModel);

      // Return the user model
      return userModel;
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? 'Error registering');
      return null;
    } catch (e) {
      _showToast('An unexpected error occurred: ${e.toString()}');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      _showToast('Error signing out');
    }
  }

  // Helper method to show toast messages
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
