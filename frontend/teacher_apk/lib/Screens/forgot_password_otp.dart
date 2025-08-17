// OTP Verification Screen (adapted from SignUpStep3Page)
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets/triangle_logo.dart'; // Added import
import '../utils/ui_constants.dart'; // Added import

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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
    // Optionally, if a digit is deleted, move focus to the previous field
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Potentially receive email passed as an argument
    // final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'your.email@example.com';

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
                    // Profile Avatar (copied from forgot_password_email.dart)
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
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            // Heading
                            Text(
                              'Enter the OTP sent to your registered email', // Changed Title
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              "Please check your email now.",
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(250),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),

                            const SizedBox(height: 90),

                            Text(
                              "Verify your account",
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(250),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            // Email Info Text (can be made dynamic if email is passed)
                            Text(
                              "Please enter the six digit verification code sent to your registered email to proceed further.", // Generic text
                              // Example with dynamic email:
                              // "We\'ve sent a verification code to your registered email address \n$email",
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(250),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

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
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding for the line
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppTheme.primaryColor.withAlpha((255 * 0.5).round())),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2.0),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) => _onCodeDigitChanged(index, value),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Verify Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add your OTP verification logic here
                                  // For now, navigates to 'verificationComplete'
                                  // This should likely navigate to a Reset Password screen
                                  Navigator.pushNamed(context, 'newPassword');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Verify OTP', // Changed button text
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // Adjusted spacing


                            // Resend Code
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.primaryColor,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Didn't receive any code? ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400, // Light font
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Resend now',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Add your resend code logic here
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Resend code logic to be implemented')),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             const SizedBox(height: 20), // Adjusted spacing if needed
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
