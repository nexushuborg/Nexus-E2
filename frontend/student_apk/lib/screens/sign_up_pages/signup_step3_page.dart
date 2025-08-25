import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';
import 'package:student_apk/widgets/glass_frame.dart';

class SignUpStep3Page extends StatefulWidget {
  const SignUpStep3Page({super.key});

  @override
  State<SignUpStep3Page> createState() => _SignUpStep3PageState();
}

class _SignUpStep3PageState extends State<SignUpStep3Page> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? email;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
                      onPressed: () => Navigator.pushReplacementNamed(context, Routes.signupStep2),
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

              // Header
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
                      'Verification',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Glass Frame Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: GlassFrame(
                    borderRadius: BorderRadius.circular(40),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Code',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We've sent a verification code to your registered email address ${email ?? 'your email'}",
                            style: TextStyle(
                              color: AppTheme.textColor.withAlpha(178),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // OTP Input Fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    color: AppTheme.textColor2,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) => _onCodeDigitChanged(index, value),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Resend Code Button
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                String code = _controllers.map((c) => c.text).join();
                                if (code.length == 6) {
                                  Navigator.pushReplacementNamed(context, Routes.signupStep4);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.buttonBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  color: AppTheme.textColor2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Step Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 2 ? AppTheme.buttonBg : AppTheme.textColor.withAlpha(76),
                              ),
                            )),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Step 3 of 4',
                              style: TextStyle(
                                color: AppTheme.textColor.withAlpha(178),
                                fontSize: 14,
                              ),
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
