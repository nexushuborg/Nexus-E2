// Main entry point for the teacher_apk Flutter app
import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login.dart';
import 'screens/loading.dart';
import 'screens/get_started_page.dart';
import 'screens/signup_step1_page.dart';
import 'screens/signup_step2_page.dart';
import 'screens/signup_step3_page.dart';
import 'screens/verification_complete_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/upload_notes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.themeData,
    initialRoute: 'loading',
    routes: {
      'loading': (context) => const LoadingScreen(),
      'getStarted': (context) => const GetStartedPage(),
      'login': (context) => const ArcanumLogin(),
      'signupStep1': (context) => const SignUpStep1Page(),
      'signupStep2': (context) => const SignUpStep2Page(),
      'signupStep3': (context) => const SignUpStep3Page(),
      'verificationComplete': (context) => const VerificationCompletePage(),
      'dashboard': (context) => const DashboardPage(),
      'profile': (context) => const ProfilePage(),
      'settings': (context) => const SettingsPage(),
      'uploadNotes': (context) => const UploadNotesScreen(),
    },
  ));
}