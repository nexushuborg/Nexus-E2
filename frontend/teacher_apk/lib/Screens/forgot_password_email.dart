import 'package:flutter/material.dart';
import 'package:teacher_apk/Screens/forgot_password_otp.dart';
import 'package:teacher_apk/theme.dart';
import 'package:teacher_apk/utils/ui_constants.dart';
import 'package:teacher_apk/widgets/triangle_logo.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: UIConstants.iconSizeLarge),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: UIConstants.iconSizeLarge / 1.0,
              child: const TriangleLogo(size: UIConstants.iconSizeLarge / 1.6, isWhite: true),
            ),
            onPressed: () {
              // Handle profile icon tap
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  "Use your email to reset your password",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                // controller: TextEditingController(), // Add controller if needed for state management
                style: const TextStyle(color: Colors.black87), // Style from Login.dart's _EmailTextField
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  hintStyle: TextStyle(color: Colors.grey.shade600), // Style from Login.dart's _EmailTextField
                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor), // Changed from person_outline
                  // border: AppTheme.inputBorder, // If you have a global input border in your theme
                  // Filled and border style from AppTheme.themeData if applicable
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8.0), // Space before the alert message
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20.0),
                  const SizedBox(width: 8.0),
                  Expanded( // To allow text to wrap if it's long
                    child: Text(
                      'Please use your college email ID',
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0), // Space after the alert message, before the button
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
                  // Foreground color (text color) can also be set if needed
                  // foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
                  );
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
