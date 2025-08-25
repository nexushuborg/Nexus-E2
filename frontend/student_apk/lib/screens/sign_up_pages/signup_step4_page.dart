import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';
import 'package:student_apk/widgets/glass_frame.dart';

class SignUpStep4Page extends StatefulWidget {
  const SignUpStep4Page({super.key});

  @override
  State<SignUpStep4Page> createState() => _SignUpStep4PageState();
}

class _SignUpStep4PageState extends State<SignUpStep4Page> {
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
                      onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep3),
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
                      'College ID Verification',
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
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Please upload a clear scanned copy of your valid college ID card for verification.',
                            style: TextStyle(
                              color: AppTheme.textColor.withAlpha(178),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Upload Box
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.buttonBg.withAlpha(76),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: AppTheme.buttonBg.withAlpha(178),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.buttonBg,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Upload',
                                        style: TextStyle(
                                          color: AppTheme.textColor2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.upload,
                                        color: AppTheme.textColor2,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Only .pdf files are accepted.',
                            style: TextStyle(
                              color: AppTheme.textColor.withAlpha(178),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),

                          // Complete Profile Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.buttonBg,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppTheme.backgroundGradientStart,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text(
                                        'Profile Created!',
                                        style: TextStyle(
                                          color: AppTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Your profile has been created successfully.',
                                        style: TextStyle(
                                          color: AppTheme.textColor.withAlpha(204),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.pushReplacementNamed(context, Routes.verificationComplete);
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Complete Profile',
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
                                    color: index == 3 ? AppTheme.textColor : AppTheme.textColor.withAlpha(76),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Step 4 of 4',
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
