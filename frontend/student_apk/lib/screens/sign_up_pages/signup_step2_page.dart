import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';
import '../../widgets/glass_frame.dart';

class SignUpStep2Page extends StatefulWidget {
  const SignUpStep2Page({super.key});

  @override
  State<SignUpStep2Page> createState() => _SignUpStep2PageState();
}

class _SignUpStep2PageState extends State<SignUpStep2Page> {
  String? _academicYear;
  String? _degree;
  String? _department;

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
                      onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep1),
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
                      'Academic Information',
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
                          // Registration Number
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const TextField(
                              style: TextStyle(color: AppTheme.textColor2),
                              decoration: InputDecoration(
                                hintText: 'Enter your college registration number',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Academic Year Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Choose your academic year', style: TextStyle(color: Colors.grey)),
                                value: _academicYear,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                items: ['1st Year', '2nd Year', '3rd Year', '4th Year']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e, style: const TextStyle(color: AppTheme.textColor2)),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _academicYear = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Degree Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Choose your degree', style: TextStyle(color: Colors.grey)),
                                value: _degree,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                items: ['B.Tech', 'M.Tech', 'PhD']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e, style: const TextStyle(color: AppTheme.textColor2)),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _degree = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Department Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Choose your department', style: TextStyle(color: Colors.grey)),
                                value: _department,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                items: ['CSE', 'ECE', 'EE', 'ME', 'CE']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e, style: const TextStyle(color: AppTheme.textColor2)),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _department = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section Field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const TextField(
                              style: TextStyle(color: AppTheme.textColor2),
                              decoration: InputDecoration(
                                hintText: 'Enter your section',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
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
                              onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep3),
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
                                    color: index == 1 ? AppTheme.textColor : AppTheme.textColor.withAlpha(76),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Step 2 of 4',
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
