import 'package:flutter/material.dart';
import 'package:student_apk/routes.dart';
import 'package:student_apk/screens/loading.dart';
import 'package:student_apk/screens/get_started_page.dart';
import 'package:student_apk/screens/login.dart';
import 'package:student_apk/screens/sign_up_pages/signup_step1_page.dart';
import 'package:student_apk/screens/sign_up_pages/signup_step2_page.dart';
import 'package:student_apk/screens/sign_up_pages/signup_step3_page.dart';
import 'package:student_apk/screens/sign_up_pages/signup_step4_page.dart';
import 'package:student_apk/screens/sign_up_pages/verification_complete_page.dart';
import 'package:student_apk/screens/dashboard_page.dart';
import 'package:student_apk/screens/profile_page.dart';
import 'package:student_apk/screens/settings_page.dart';
import 'package:student_apk/screens/materials_pages/materials_page.dart';
import 'package:student_apk/screens/materials_pages/subject_page.dart';
import 'package:student_apk/screens/materials_pages/subject_content_page.dart';
import 'package:student_apk/screens/materials_pages/files_page.dart';
import 'package:student_apk/screens/forgot_pass_pages/forgot_password_step1.dart';
import 'package:student_apk/screens/forgot_pass_pages/forgot_password_step2.dart';
import 'package:student_apk/screens/forgot_pass_pages/forgot_password_step3.dart';
import 'package:student_apk/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcanum Student',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.loading,
      routes: {
        Routes.loading: (context) => const LoadingPage(),
        Routes.getStarted: (context) => const GetStartedPage(),
        Routes.login: (context) => const ArcanumLogin(),
        Routes.signupStep1: (context) => const SignUpStep1Page(),
        Routes.signupStep2: (context) => const SignUpStep2Page(),
        Routes.signupStep3: (context) => const SignUpStep3Page(),
        Routes.signupStep4: (context) => const SignUpStep4Page(),
        Routes.verificationComplete: (context) => const VerificationCompletePage(),
        Routes.dashboard: (context) => const DashboardPage(),
        Routes.profile: (context) => const ProfilePage(),
        Routes.settings: (context) => const SettingsPage(),
        Routes.materials: (context) => const MaterialsPage(),
        Routes.subject: (context) => const SubjectPage(),
        Routes.subjectContent: (context) => const SubjectContentPage(),
        Routes.files: (context) => const FilesPage(),
        Routes.forgotPasswordStep1: (context) => const ForgotPasswordStep1(),
        Routes.forgotPasswordStep2: (context) => const ForgotPasswordStep2(),
        Routes.forgotPasswordStep3: (context) => const ForgotPasswordStep3(),
      },
    );
  }
}
