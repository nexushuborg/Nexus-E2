import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';
import '../../widgets/glass_frame.dart';

class SignUpStep1Page extends StatefulWidget {
  const SignUpStep1Page({super.key});

  @override
  State<SignUpStep1Page> createState() => _SignUpStep1PageState();
}

class _SignUpStep1PageState extends State<SignUpStep1Page> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
                      onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.textColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('Δ', style: TextStyle(color: AppTheme.backgroundGradientStart, fontSize: 24)),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Profile',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Profile Information',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: GlassFrame(
                    borderRadius: BorderRadius.circular(40),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        children: [
                          // Form Fields with white background
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const TextField(
                              style: TextStyle(color: AppTheme.textColor2),
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Gender Dropdown with light background
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Gender', style: TextStyle(color: Colors.grey)),
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                items: ['Male', 'Female', 'Other']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e, style: const TextStyle(color: AppTheme.textColor2)),
                                        ))
                                    .toList(),
                                onChanged: (value) {},
                                style: const TextStyle(color: AppTheme.textColor2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email Field with warning
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const TextField(
                              style: TextStyle(color: AppTheme.textColor2),
                              decoration: InputDecoration(
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_outlined, color: AppTheme.buttonBg, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Please use your official email ID.',
                                style: TextStyle(
                                  color: AppTheme.textColor.withAlpha(178),  // Changed from withOpacity(0.7)
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Password Fields with eye icon
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
                                hintText: 'Create your new password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(color: AppTheme.textColor2),
                              decoration: InputDecoration(
                                hintText: 'Re-enter your new password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Next button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.buttonBg,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep2),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: AppTheme.textColor2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: AppTheme.textColor2),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Step Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: index == 0 ? AppTheme.textColor : AppTheme.textColor.withAlpha(76),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Step 1 of 4',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
}
