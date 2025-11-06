import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../models/signup_data.dart';
import '../../theme.dart';
import '../../mixins/form_styling_mixin.dart';

class SignUpStep1Page extends StatefulWidget {
  const SignUpStep1Page({Key? key}) : super(key: key);

  @override
  State<SignUpStep1Page> createState() => _SignUpStep1PageState();
}

class _SignUpStep1PageState extends State<SignUpStep1Page>
    with FormStylingMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  final SignupData _signupData = SignupData();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration({
    required String labelText,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: labelText,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: AppTheme.textColor2.withOpacity(0.6),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.backgroundGradientStart,
            AppTheme.backgroundGradientEnd
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, Routes.getStarted),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'Δ',
                            style: TextStyle(
                              color: Color(0xFF2C1F45),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: AppTheme.textColor2,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _getInputDecoration(
                            labelText: 'Enter your full name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onSaved: (value) => _signupData.fullName = value!,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: _getInputDecoration(
                            labelText: 'Choose your gender',
                          ),
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF8E4EC6)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _signupData.gender = value?.toLowerCase();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(
                                color: AppTheme.textColor2,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: _getInputDecoration(
                                labelText: 'SOA Email Address',
                                errorText: _emailError,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your college email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) => _signupData.email = value!,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppTheme.buttonBg,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Please use your official email ID.',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          style: const TextStyle(
                            color: AppTheme.textColor2,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _getInputDecoration(
                            labelText: 'Mobile number',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                          onSaved: (value) => _signupData.phoneNo = value!,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(
                                color: AppTheme.textColor2,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              obscureText: _obscurePassword,
                              decoration: _getInputDecoration(
                                labelText:
                                    'Create your new password (must contain A-Z, a-z, 0-9, !@#\$%^&*)',
                                errorText: _passwordError,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF666666),
                                    size: 24,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return 'Password must contain at least one uppercase letter';
                                }
                                if (!value.contains(RegExp(r'[a-z]'))) {
                                  return 'Password must contain at least one lowercase letter';
                                }
                                if (!value.contains(RegExp(r'[0-9]'))) {
                                  return 'Password must contain at least one number';
                                }
                                if (!value.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  return 'Password must contain at least one special character';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (_passwordError != null) {
                                  setState(() => _passwordError = null);
                                }
                              },
                              onSaved: (value) => _signupData.password = value!,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: AppTheme.buttonBg,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Password must contain:',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• At least one uppercase letter (A-Z)',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '• At least one lowercase letter (a-z)',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '• At least one number (0-9)',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '• At least one special character (!@#\$%^&*)',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          style: const TextStyle(
                            color: AppTheme.textColor2,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          obscureText: _obscureConfirmPassword,
                          decoration: _getInputDecoration(
                            labelText: 'Re-enter your new password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF666666),
                                size: 24,
                              ),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _emailError = null;
                                      _passwordError = null;
                                    });

                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      _formKey.currentState!.save();

                                      // Validate email domain
                                      if (!_emailController.text
                                          .contains('@')) {
                                        setState(() {
                                          _emailError =
                                              'Please use your SOA email address';
                                          _isLoading = false;
                                        });
                                        return;
                                      }

                                      // Save data to signup model
                                      _signupData.fullName =
                                          _nameController.text;
                                      _signupData.email = _emailController.text;
                                      _signupData.password =
                                          _passwordController.text;
                                      _signupData.phoneNo =
                                          _mobileController.text;
                                      _signupData.gender = _selectedGender;

                                      // Proceed to next step
                                      Navigator.pushNamed(
                                        context,
                                        Routes.signupStep2,
                                        arguments: _signupData,
                                      );

                                      setState(() => _isLoading = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8E4EC6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8E4EC6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Step 1 of 3',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
