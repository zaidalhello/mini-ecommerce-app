import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniecommerceapp/models/user_model.dart';
import 'package:miniecommerceapp/firebase_config.dart';

class FirestoreService {
  // Use the configured Firestore instance with 'ministore' database
  final FirebaseFirestore _db = FirebaseConfig.getFirestore();

  // Reference to the users collection
  CollectionReference get usersRef => _db.collection('users');

  // Save user data to Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      await usersRef.doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await usersRef.doc(uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await usersRef.doc(uid).update(data);
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
}
