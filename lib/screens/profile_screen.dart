import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniecommerceapp/models/user_model.dart';
import 'package:miniecommerceapp/providers/auth_provider.dart';
import 'package:miniecommerceapp/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  UserModel? _userProfile;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Load user profile data from Firestore
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user != null && user.uid != null) {
        // Get complete user data from Firestore
        final userData = await _firestoreService.getUserData(user.uid!);

        if (userData != null) {
          setState(() {
            // Use the existing user data or the data from Firestore
            _userProfile = userData;

            // Set the text field controllers
            _emailController.text = userData.email ?? '';
            _fullNameController.text = userData.fullName ?? '';
            _phoneNumberController.text = userData.phoneNumber ?? '';
          });
        } else {
          // If no Firestore data exists yet, use data from auth user
          setState(() {
            _userProfile = UserModel(
              uid: user.uid,
              email: user.email,
              // Firebase Auth User doesn't have fullName or phoneNumber
              fullName: '',
              phoneNumber: '',
            );

            // Set the text field controllers with available data
            _emailController.text = user.email ?? '';
            _fullNameController.text = ''; // No fullName in Firebase Auth User
            _phoneNumberController.text =
                ''; // No phoneNumber in Firebase Auth User
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No user is currently logged in';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save updated user profile to Firestore
  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user != null && user.uid != null && _userProfile != null) {
        // Create updated user data map
        final updatedData = {
          'email': _emailController.text.trim(),
          'fullName': _fullNameController.text.trim(),
          'phoneNumber': _phoneNumberController.text.trim(),
        };

        // Update profile using AuthProvider
        final success = await authProvider.updateUserProfile(
          user.uid!,
          updatedData,
        );

        if (success) {
          // Show success message
          Fluttertoast.showToast(
            msg: 'Profile updated successfully',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Reload profile data to show the updated information
          await _loadUserProfile();
        } else {
          // Show error message
          setState(() {
            _errorMessage = 'Failed to update profile';
          });

          Fluttertoast.showToast(
            msg: 'Failed to update profile',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating profile: ${e.toString()}';
      });

      Fluttertoast.showToast(
        msg: 'Failed to update profile',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadUserProfile,
            tooltip: 'Reload Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty && _userProfile == null
          ? _buildErrorView()
          : _buildProfileForm(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserProfile,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Edit Your Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                // Simple email validation
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              readOnly: true, // Email should not be editable
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              prefixIcon: Icons.badge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneNumberController,
              label: 'Phone Number',
              prefixIcon: Icons.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                // Basic phone number validation (can be enhanced)
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveUserProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey[100] : null,
      ),
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
    );
  }
}
