// Verification Complete screen after sign up
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';

class VerificationCompletePage extends StatefulWidget {
  const VerificationCompletePage({super.key});

  @override
  State<VerificationCompletePage> createState() => _VerificationCompletePageState();
}

class _VerificationCompletePageState extends State<VerificationCompletePage> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate to dashboard after 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Add this check
        Navigator.pushReplacementNamed(context, 'dashboard');
      }
    });
  }

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
          child: Stack(
            children: [
              // Top Bar
              Positioned(
                top: 16,
                left: 8,
                right: 24,
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

              // Content Card
              Positioned(
                top: 170,
                bottom: 170,
                left: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32), // Adjusted padding
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51), // Changed from withOpacity(0.2)
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                    // mainAxisSize: MainAxisSize.min, // Removed: Column will now expand
                    children: [
                      // Success Message
                      Text(
                        'Verification Complete!',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // Check Icon with Circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51), // Changed from withOpacity(0.2)
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Logo at the bottom
              Positioned(
                bottom: 60, // Adjust as needed
                left: 0,
                right: 0,
                child: Center(
                  child: ArcanumLogo(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
