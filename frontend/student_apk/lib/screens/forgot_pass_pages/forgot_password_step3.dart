import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';

class ForgotPasswordStep3 extends StatefulWidget {
  const ForgotPasswordStep3({super.key});

  @override
  State<ForgotPasswordStep3> createState() => _ForgotPasswordStep3State();
}

class _ForgotPasswordStep3State extends State<ForgotPasswordStep3> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.warning_rounded, color: AppTheme.textColor),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Secure your account with new password',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a new password',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Change Password',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppTheme.textColor2),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: AppTheme.textColor2),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'Re-enter your new password',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text == _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset successfully!'),
                            backgroundColor: AppTheme.buttonBg,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, Routes.login);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: AppTheme.textColor2,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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
