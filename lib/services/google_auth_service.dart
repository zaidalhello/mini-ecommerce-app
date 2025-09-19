import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miniecommerceapp/firebase_config.dart';
import 'package:miniecommerceapp/models/user_model.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseConfig.getFirestore();

  // Method to handle Google Sign-In process
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Handle user cancelling the Google Sign In
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      _showToast('Google sign-in failed: ${e.toString()}');
      return null;
    }
  }

  // Create or update user data in Firestore after Google Sign In
  Future<UserModel?> createUserInFirestore(
    User user, {
    String? fullName,
  }) async {
    try {
      // Use email as fullName if not provided
      final String displayName =
          fullName ?? user.email?.split('@')[0] ?? 'User';

      // Reference to the users collection
      DocumentReference userDocRef = _db.collection('users').doc(user.uid);

      // Check if user document exists
      DocumentSnapshot doc = await userDocRef.get();

      Map<String, dynamic> userData;

      if (!doc.exists) {
        // Create new user document if it doesn't exist
        userData = {
          'uid': user.uid,
          'email': user.email,
          'fullName': displayName,
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await userDocRef.set(userData);
      } else {
        // Update the existing user document
        userData = doc.data() as Map<String, dynamic>;

        await userDocRef.update({
          'updatedAt': FieldValue.serverTimestamp(),
          // Only update email if it's changed to preserve existing data
          if (user.email != null && user.email != userData['email'])
            'email': user.email,
        });
      }

      // Get the updated document
      DocumentSnapshot updatedDoc = await userDocRef.get();
      return UserModel.fromFirestore(updatedDoc.data() as Map<String, dynamic>);
    } catch (e) {
      _showToast('Error saving user data: ${e.toString()}');
      return null;
    }
  }

  // Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      _showToast('Error signing out: ${e.toString()}');
      throw e;
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
