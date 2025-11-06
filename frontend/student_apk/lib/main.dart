import 'package:flutter/material.dart';
import 'routes.dart';

import 'screens/loading.dart';
import 'screens/get_started_page.dart';
import 'screens/login.dart';
import 'screens/dashboard_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/forgot_pass_pages/forgot_password_step1.dart';
import 'screens/forgot_pass_pages/forgot_password_step2.dart';
import 'screens/forgot_pass_pages/forgot_password_step3.dart';
import 'screens/materials_pages/materials_page.dart';
import 'screens/materials_pages/subject_page.dart';
import 'screens/materials_pages/chapter_page.dart';
import 'screens/materials_pages/assignments_page.dart';
import 'screens/materials_pages/pyqs_page.dart';
import 'screens/materials_pages/lab_work_page.dart';
import 'screens/materials_pages/subject_content_page.dart';
import 'screens/materials_pages/files_page.dart';
import 'screens/sign_up_pages/signup_step1_page.dart';
import 'screens/sign_up_pages/signup_step2_page.dart';
import 'screens/sign_up_pages/signup_step3_page.dart';
import 'screens/sign_up_pages/signup_step4_page.dart';
import 'screens/sign_up_pages/verification_complete_page.dart';
import 'models/signup_data.dart';
import 'theme.dart';

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
        Routes.signupStep2: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return SignUpStep2Page(signupData: args as SignupData);
        },
        Routes.signupStep3: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return SignUpStep3Page(signupData: args as SignupData);
        },
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/forgot-password-step1': (context) => const ForgotPasswordStep1Page(),
        '/forgot-password-step2': (context) => const ForgotPasswordStep2Page(),
        '/forgot-password-step3': (context) => const ForgotPasswordStep3Page(),
        '/materials': (context) => const MaterialsPage(),
        '/materials/subject': (context) => const SubjectPage(),
        '/materials/subject/chapters': (context) => const ChapterPage(),
        '/materials/subject/assignments': (context) => const AssignmentsPage(),
        '/materials/subject/pyqs': (context) => const PyqsPage(),
        '/materials/subject/lab': (context) => const LabWorkPage(),
        '/materials/subject/content': (context) => const SubjectContentPage(),
        '/materials/subject/files': (context) => const FilesPage(),
        '/signup-step4': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return SignUpStep4Page(signupData: args as SignupData);
        },
        '/verification-complete': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return const VerificationCompletePage();
        },
      },
    );
  }
}
