# Mini E-Commerce Flutter App

A modern, feature-rich mini e-commerce mobile application built with Flutter and Firebase. This app demonstrates a complete shopping experience with user authentication, product browsing, cart management, and payment integration.

## 📱 Project Overview

This Mini E-Commerce app provides a streamlined shopping experience with secure authentication, real-time product data from Firebase Firestore, and an intuitive user interface. The app follows modern Flutter development practices with clean architecture, state management using Provider, and seamless Firebase integration.

## ✨ Features Implemented

### 🔐 Authentication
- **Firebase Authentication** with Email/Password login and registration
- **Google Sign-In** integration for quick access
- Secure user session management
- User profile management with Firestore integration

### 🛍️ Product Management
- **Product listing** from Firebase Firestore with real-time updates
- **Cached network images** for optimal performance using `cached_network_image`
- **Product details page** with comprehensive product information
- **Add-to-cart functionality** with quantity selection

### 🛒 Shopping Cart
- **Cart management** using Provider state management
- **Add/Remove/Update quantities** with real-time calculations
- **Persistent cart state** across app sessions
- **Order summary** with total price calculations

### 👤 User Profile
- **User profile screen** with Firestore integration
- **Profile information management**
- **Authentication status tracking**

### 💳 Payment Integration
- **Stripe payment integration** (placeholder setup)
- **Payment result screens** for transaction feedback

> **Note:** Stripe payment integration requires a backend API (e.g., Firebase Cloud Functions or custom server) to handle secure payment processing. Full implementation cannot be completed on Firebase's free Spark plan due to external API limitations.

## 🚀 Installation Instructions

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Git

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/miniecommerceapp.git
   cd miniecommerceapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication with Email/Password and Google Sign-In providers
   - Create a Firestore database in test mode
   - Add your Android/iOS app to the Firebase project
   - Download and place the configuration files:
     - `google-services.json` in `android/app/`
     - `GoogleService-Info.plist` in `ios/Runner/`

4. **Google Sign-In Setup**
   - Configure OAuth consent screen in Google Cloud Console
   - Add SHA-1 fingerprint for Android in Firebase project settings

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ App Structure

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point and initialization
├── firebase_config.dart      # Firebase configuration
├── firebase_options.dart     # Auto-generated Firebase options
├── models/                   # Data models
│   ├── cart_item_model.dart  # Cart item data structure
│   ├── product_model.dart    # Product data structure
│   └── user_model.dart       # User data structure
├── providers/                # State management (Provider pattern)
│   ├── auth_provider.dart    # Authentication state management
│   ├── cart_provider.dart    # Cart state management
│   ├── payment_provider.dart # Payment state management
│   └── product_provider.dart # Product state management
├── screens/                  # UI screens
│   ├── auth_wrapper.dart     # Authentication flow wrapper
│   ├── login_screen.dart     # Login and registration UI
│   ├── home_screen.dart      # Product listing UI
│   ├── product_detail_screen.dart # Product details UI
│   ├── cart_screen.dart      # Shopping cart UI
│   ├── profile_screen.dart   # User profile UI
│   └── payment_result_screen.dart # Payment result UI
└── services/                 # Business logic and external APIs
    ├── auth_service.dart     # Authentication services
    ├── firestore_service.dart # Firestore database operations
    ├── google_auth_service.dart # Google Sign-In services
    └── payment_service.dart  # Payment processing services
```

### Architecture Principles
- **Services Layer**: Handles business logic and external API communications
- **Providers Layer**: Manages application state using the Provider pattern
- **Screens Layer**: Contains UI components and user interactions
- **Models Layer**: Defines data structures and serialization

## 🔧 How to Run

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Development Mode
```bash
flutter run --debug
```

### Release Mode
```bash
flutter run --release
```

> **✅ Testing Status:** This app has been successfully tested and runs smoothly on Android devices. iOS testing requires a macOS environment with Xcode installed.

## 📱 Screenshots

### Authentication
<div style="display: flex; gap: 20px;">
    <!-- First Image -->
    <img src="https://github.com/user-attachments/assets/90fb856a-17a8-4e17-9171-fc374b889491" alt="Screenshot 1"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">
    <img src="https://github.com/user-attachments/assets/3508ba0e-0c99-4d95-aa13-f5b0cc4719b5" alt="Screenshot 2"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">
  </div>

### Product Management
<div style="display: flex; gap: 20px;">
    <!-- First Image -->
    <img src="https://github.com/user-attachments/assets/7cb637b6-3287-451a-8ed7-87a6f9ebf9e5" alt="Screenshot 1"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">
    <img src="https://github.com/user-attachments/assets/d97d42bd-c22d-4132-a6ad-a05ec9767dd0" alt="Screenshot 2"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">
  </div>
### Shopping Cart
<div style="display: flex; gap: 20px;">
    <!-- First Image -->
    <img src="https://github.com/user-attachments/assets/32650d4b-852c-4d63-a4ac-f47de87aae37" alt="Screenshot 1"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">

  </div>
### User Profile
<div style="display: flex; gap: 20px;">
    <!-- First Image -->
    <img src="https://github.com/user-attachments/assets/d0423e16-3995-4688-bc90-cc3251f0de73" alt="Screenshot 1"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">

  </div>

### Payment
<div style="display: flex; gap: 20px;">
    <!-- First Image -->
    <img src="https://github.com/user-attachments/assets/191b7ab5-f35e-4404-b174-ae52ce5dbdc7" alt="Screenshot 1"
         style="border: 3px solid black; border-radius: 15px; width: 300px;">

  </div>
  
## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL database
- **Provider** - State management
- **Google Sign-In** - OAuth authentication
- **Cached Network Image** - Image caching and loading
- **Flutter Stripe** - Payment integration
- **HTTP** - API communication


**Made with ❤️ using Flutter**
