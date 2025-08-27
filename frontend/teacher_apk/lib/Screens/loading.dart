// ================== Imports ==================
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart';
import 'package:teacher_apk/widgets/triangle_logo.dart';
import 'package:teacher_apk/widgets/arcanum_logo.dart';

// ================== Loading Screen ==================
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // ================== Init State ==================
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('getStarted');
      }
    });
  }

  // ================== Build Method ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              child: TriangleLogo(size: 100, isWhite: true),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 430),
                  const ArcanumLogo(fontSize: 40, color: AppTheme.primaryColor),
                  const SizedBox(height: 10),
                  const Text(
                    "Teach smarter. Manage faster",
                    style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 50),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
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
