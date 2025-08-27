// New Password Page: Set a new password for your account
import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart';
import 'package:teacher_apk/widgets/triangle_logo.dart';
import 'package:teacher_apk/utils/ui_constants.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _onResetPasswordPressed() {
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pushReplacementNamed(context, 'forgotPasswordOtp'),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: UIConstants.iconSizeLarge / 1.5,
                        child: const TriangleLogo(size: UIConstants.iconSizeLarge / 1.5, isWhite: true),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, top: 20, right: 35, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.backgroundGradientStart,
          AppTheme.backgroundGradientEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

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
        Center(
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
      ),
    );
  }
}

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
