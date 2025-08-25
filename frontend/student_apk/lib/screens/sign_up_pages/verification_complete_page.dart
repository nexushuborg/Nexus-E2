import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';

class VerificationCompletePage extends StatefulWidget {
  const VerificationCompletePage({super.key});

  @override
  State<VerificationCompletePage> createState() => _VerificationCompletePageState();
}

class _VerificationCompletePageState extends State<VerificationCompletePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Text(
                'Verification Complete!',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.buttonBg.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: AppTheme.buttonBg,
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Arcanum',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 20,
                  fontFamily: 'MajorMonoDisplay',
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
