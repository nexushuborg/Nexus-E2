import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';

class ForgotPasswordStep1 extends StatelessWidget {
  const ForgotPasswordStep1({super.key});

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
                  'Use your email to reset your password',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textColor2),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'Enter your email address',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Icon(Icons.warning_rounded, color: AppTheme.textColor, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Please use your college email ID.',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.forgotPasswordStep2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Continue',
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
