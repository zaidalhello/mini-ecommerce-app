class UserModel {
  final String? uid;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String?
  provider; // Added provider field to identify auth method (email, google, etc)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.provider,
    this.createdAt,
    this.updatedAt,
  });

  // Create a copy of this UserModel but with the given fields replaced with new values
  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? provider,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create a user from Firebase User
  factory UserModel.fromFirebaseUser(user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      // Firebase Auth User doesn't have fullName
    );
  }

  // Create a user from Firebase User and additional data
  factory UserModel.fromFirebaseUserWithData(
    user,
    Map<String, dynamic> userData,
  ) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      fullName: userData['fullName'],
      phoneNumber: userData['phoneNumber'],
      provider: userData['provider'],
      createdAt: userData['createdAt']?.toDate(),
      updatedAt: userData['updatedAt']?.toDate(),
    );
  }

  // Convert user model to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'provider': provider,
      // Don't include timestamps in the map as they're handled separately
    };
  }

  // Create a user model from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      provider: data['provider'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }
}
