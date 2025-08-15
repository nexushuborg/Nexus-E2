import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart'; // Import AppTheme
import 'package:teacher_apk/widgets/triangle_logo.dart'; // Import TriangleLogo
import 'package:teacher_apk/widgets/arcanum_logo.dart'; // Import ArcanumLogo

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('getStarted');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( // Wrap body with Container for gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: const TriangleLogo(size: 100, isWhite: true), // Changed to white
            ),
            Align(
              alignment: Alignment.center, // This centers the Column horizontally
              child: Column(
                mainAxisSize: MainAxisSize.min, // So it only takes needed vertical space
                children: <Widget>[
                  const SizedBox(height: (80 / 2) + 380), // 40 + 380 = 420. Should be (100/2) + new_spacing
                  const ArcanumLogo(fontSize: 40, color: AppTheme.primaryColor),
                  const SizedBox(height: 10),
                  const Text(
                    "Teach smarter. Manage faster",
                    style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: AppTheme.primaryColor), // Added text with small font
                  ),
                  const SizedBox(height: 50), // Spacing after text, consistent with previous layout
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor), // Use primaryColor
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
