import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class FirebaseConfig {
  // Initialize Firebase with the named database
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Get Firestore instance for the 'ministore' database
  static FirebaseFirestore getFirestore() {
    return FirebaseFirestore.instance;
  }
}
