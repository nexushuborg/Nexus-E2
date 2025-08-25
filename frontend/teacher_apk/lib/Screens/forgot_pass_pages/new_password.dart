import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart';
import 'package:teacher_apk/widgets/triangle_logo.dart';
import 'package:teacher_apk/utils/ui_constants.dart';

// Main widget for the New Password screen.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

// State class for NewPasswordScreen. Manages the mutable state of the screen.
class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // Controllers for handling the text input in password fields.
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variable for UI interactions.
  bool _isPasswordObscured = true; // Tracks whether the password text is hidden.

  // Dispose of controllers when the widget is removed from the widget tree to free up resources.
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Toggles the visibility of the password text.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  // Handles the reset password button press event.
  void _onResetPasswordPressed() {
    // String newPassword = _newPasswordController.text;
    // String confirmPassword = _confirmPasswordController.text;
    // TODO: Implement password validation (e.g., check if they match)
    // TODO: Implement actual password reset logic here.
    Navigator.pushReplacementNamed(context, 'login');
  }

  // Builds the UI for the new password screen.
  @override
  Widget build(BuildContext context) {
    return Container(
      // Applies a gradient background to the entire screen.
      decoration: _buildBackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Makes scaffold background transparent to show container's gradient.
        body: SafeArea( // Added SafeArea
          child: Column( // Added Column to host top bar and content
            children: [
              // Top Bar (copied from forgot_password_otp.dart)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pushReplacementNamed(context, 'forgotPasswordOtp'),
                    ),
                    const Spacer(),
                    // Profile Avatar
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: UIConstants.iconSizeLarge / 1.5,
                        child: const TriangleLogo(size: UIConstants.iconSizeLarge / 1.5, isWhite: true),
                      ),
                      onPressed: () {
                        // Handle profile icon tap
                        // Example: Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ],
                ),
              ),
              Expanded( // Content will now scroll within Expanded
                child: SingleChildScrollView( 
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, top: 20, right: 35, bottom: 20), // Adjusted top padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      mainAxisSize: MainAxisSize.min, 
                      children: <Widget>[
                        // const Center(child: ArcanumLogo(color: AppTheme.primaryColor, fontSize: 25)), // Removed Arcanum Logo
                        // const SizedBox(height: 80), // Spacing after logo removed
                        const _NewPasswordHeader(), 
                        const SizedBox(height: 30),
                        _PasswordTextField( 
                          controller: _newPasswordController,
                          isObscured: _isPasswordObscured,
                          onToggleVisibility: _togglePasswordVisibility,
                          hintText: 'Enter your new password',
                        ),
                        const SizedBox(height: 20), 
                        _PasswordTextField( 
                          controller: _confirmPasswordController,
                          isObscured: _isPasswordObscured,
                          onToggleVisibility: _togglePasswordVisibility,
                          hintText: 'Re-enter your new password',
                        ),
                        const SizedBox(height: 40), 
                        _ResetPasswordButton(onPressed: _onResetPasswordPressed), 
                        const SizedBox(height: 50), 
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create the background gradient decoration.
  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.backgroundGradientStart,
          AppTheme.backgroundGradientEnd,
        ],
        begin: Alignment.topLeft, // Changed from topCenter to topLeft for consistency if needed
        end: Alignment.bottomRight, // Changed from bottomCenter to bottomRight
      ),
    );
  }
}

// The following listed below are Reusable Widget Components >>>

// Widget to display the header section of the new password screen.
class _NewPasswordHeader extends StatelessWidget {
  const _NewPasswordHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure your account with new password',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Create a strong password',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 70),

        Center( // Centered the "Change Password" Text
          child: Text(
            'Change Password',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for the password input text field. (Reused and made more generic)
class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback onToggleVisibility;
  final String hintText;

  const _PasswordTextField({
    required this.controller,
    required this.isObscured,
    required this.onToggleVisibility,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      obscureText: isObscured,
      decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.primaryColor,
              ),
              onPressed: onToggleVisibility,
            ),
          ).copyWith(
             // Apply specific overrides if the theme's defaults aren't enough
          ),
    );
  }
}

// Widget for the reset password button.
class _ResetPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ResetPasswordButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
          ),
      onPressed: onPressed,
      child: const Text('Reset Password'),
    );
  }
}
