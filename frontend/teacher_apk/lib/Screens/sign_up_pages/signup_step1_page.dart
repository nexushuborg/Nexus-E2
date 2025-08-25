// Sign Up Step 1: Profile Information
import 'package:flutter/material.dart';
import '../../theme.dart';

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32), // Original padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Part 1: Form Content
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Your Profile',
                                  style: AppTheme.themeData.textTheme.displayLarge,
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  'Profile Information',
                                  style: AppTheme.themeData.textTheme.displaySmall,
                                ),
                                const SizedBox(height: 24),

                                // Form Fields
                                TextField(
                                  style: TextStyle(color: Colors.grey.shade600),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your full name',
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Gender Dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('Gender', style: AppTheme.themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                                      items: ['Male', 'Female', 'Other']
                                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) {},
                                      style: AppTheme.themeData.textTheme.bodyLarge?.copyWith(color: AppTheme.primaryColor),
                                      dropdownColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Email Field
                                TextField(
                                  style: TextStyle(color: Colors.grey.shade600),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your email address',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Email Warning
                                Row(
                                  children: [
                                    Icon(Icons.warning, color: AppTheme.primaryColor, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Please use your official email ID.',
                                      style: AppTheme.themeData.textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Password Fields
                                TextField(
                                  style: TextStyle(color: Colors.grey.shade600),
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: 'Create your new password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: AppTheme.primaryColor,
                                      ),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  style: TextStyle(color: Colors.grey.shade600),
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    hintText: 'Re-enter your new password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: AppTheme.primaryColor,
                                      ),
                                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Part 2: Button and Indicator
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, 'signupStep2'),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('Next'),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Step Indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Step 1 of 3',
                                  style: AppTheme.themeData.textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
