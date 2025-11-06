import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/signup_data.dart';
import '../../services/api_service.dart';

class SignUpStep4Page extends StatefulWidget {
  final SignupData signupData;

  const SignUpStep4Page({
    super.key,
    required this.signupData,
  });

  @override
  State<SignUpStep4Page> createState() => _SignUpStep4PageState();
}

class _SignUpStep4PageState extends State<SignUpStep4Page> {
  late SignupData _signupData;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _signupData = widget.signupData;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SignupData) {
      _signupData = args;
    }
  }

  Future<void> _handleSignup(SignupData signupData) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a student ID image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload student ID image after registration
      final apiService = ApiService();
      final response = await apiService.uploadStudentId(_selectedImage!);

      if (response['success'] == true) {
        // Navigate to verification complete page
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          Routes.verificationComplete,
          arguments: {'email': signupData.email},
        );
      } else {
        throw response['message'] ?? 'Failed to upload student ID';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Upload Student ID',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please upload a clear photo of your student ID card',
                  style: TextStyle(
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: _selectedImage != null
                      ? Container(
                          width: 240,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.buttonBg),
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: 240,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.buttonBg),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: AppTheme.buttonBg,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add photo',
                                  style: TextStyle(color: AppTheme.textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonBg,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonBg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _handleSignup(_signupData),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Complete Registration',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
