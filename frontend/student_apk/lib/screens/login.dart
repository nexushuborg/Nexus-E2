import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';

class ArcanumLogin extends StatefulWidget {
  const ArcanumLogin({super.key});

  @override
  State<ArcanumLogin> createState() => _ArcanumLoginState();
}

class _ArcanumLoginState extends State<ArcanumLogin> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                const Center(
                  child: Text(
                    'Arcanum',
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 28,
                      fontFamily: 'MajorMonoDisplay',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 100),

                // Header
                const Text(
                  'Account Login',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Academic Management simplified!',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 56),

                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textColor2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your registered mail id',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      icon: const Icon(Icons.email_outlined, color: AppTheme.textColor2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppTheme.textColor2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your Password',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      icon: const Icon(Icons.lock_outline, color: AppTheme.textColor2),
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
                const SizedBox(height: 18),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value ?? false),
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) => states.contains(WidgetState.selected)
                                  ? AppTheme.buttonBg
                                  : Colors.transparent,
                            ),
                            checkColor: AppTheme.textColor2,
                            side: const BorderSide(color: AppTheme.textColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember Me',
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.forgotPasswordStep1),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, Routes.dashboard),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppTheme.textColor2,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Or Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.textColor.withAlpha(76))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.textColor.withAlpha(76))),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep1),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppTheme.buttonBg,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
