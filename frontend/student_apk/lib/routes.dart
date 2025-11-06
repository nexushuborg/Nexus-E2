import 'package:flutter/material.dart';
import 'models/signup_data.dart';
import 'screens/loading.dart';
import 'screens/get_started_page.dart';
import 'screens/login.dart';
import 'screens/sign_up_pages/index.dart';
import 'screens/dashboard_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/materials_pages/materials_page.dart';
import 'screens/materials_pages/subject_page.dart';
import 'screens/materials_pages/chapter_page.dart';
import 'screens/materials_pages/assignments_page.dart';
import 'screens/materials_pages/pyqs_page.dart';
import 'screens/materials_pages/lab_work_page.dart';
import 'screens/materials_pages/subject_content_page.dart';
import 'screens/materials_pages/files_page.dart';
import 'screens/forgot_pass_pages/forgot_password_step1.dart';
import 'screens/forgot_pass_pages/forgot_password_step2.dart';
import 'screens/forgot_pass_pages/forgot_password_step3.dart';

class Routes {
  static const String loading = '/';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String signupStep1 = '/signup-step1';
  static const String signupStep2 = '/signup-step2';
  static const String signupStep3 = '/signup-step3';
  static const String signupStep4 = '/signup-step4';
  static const String verificationComplete = '/verification-complete';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String materials = '/materials';
  static const String subject = '/materials/subject';
  static const String chapterPage = '/materials/subject/chapters';
  static const String assignments = '/materials/subject/assignments';
  static const String pyqs = '/materials/subject/pyqs';
  static const String labWork = '/materials/subject/lab';
  static const String forgotPasswordStep1 = '/forgot-password-step1';
  static const String forgotPasswordStep2 = '/forgot-password-step2';
  static const String forgotPasswordStep3 = '/forgot-password-step3';
  static const String subjectContent = '/materials/subject/content';
  static const String files = '/materials/subject/files';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case Routes.loading:
      return MaterialPageRoute(builder: (_) => const LoadingPage());
    case Routes.getStarted:
      return MaterialPageRoute(builder: (_) => const GetStartedPage());
    case Routes.login:
      return MaterialPageRoute(builder: (_) => const ArcanumLogin());
    case Routes.signupStep1:
      return MaterialPageRoute(builder: (_) => const SignUpStep1Page());
    case Routes.signupStep2:
      return MaterialPageRoute(
          builder: (_) => SignUpStep2Page(signupData: args as SignupData));
    case Routes.signupStep3:
      return MaterialPageRoute(
          builder: (_) => SignUpStep3Page(signupData: args as SignupData));
    case Routes.signupStep4:
      return MaterialPageRoute(
          builder: (_) => SignUpStep4Page(signupData: args as SignupData));
    case Routes.verificationComplete:
      return MaterialPageRoute(builder: (_) => const VerificationCompletePage());
    case Routes.dashboard:
      return MaterialPageRoute(builder: (_) => const DashboardPage());
    case Routes.profile:
      return MaterialPageRoute(builder: (_) => const ProfilePage());
    case Routes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    case Routes.materials:
      return MaterialPageRoute(builder: (_) => const MaterialsPage());
    case Routes.subject:
      return MaterialPageRoute(builder: (_) => const SubjectPage());
    case Routes.chapterPage:
      return MaterialPageRoute(builder: (_) => const ChapterPage());
    case Routes.assignments:
      return MaterialPageRoute(builder: (_) => const AssignmentsPage());
    case Routes.pyqs:
      return MaterialPageRoute(builder: (_) => const PyqsPage());
    case Routes.labWork:
      return MaterialPageRoute(builder: (_) => const LabWorkPage());
    case Routes.forgotPasswordStep1:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordStep1Page());
    case Routes.forgotPasswordStep2:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordStep2Page());
    case Routes.forgotPasswordStep3:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordStep3Page());
    case Routes.subjectContent:
      return MaterialPageRoute(builder: (_) => const SubjectContentPage());
    case Routes.files:
      return MaterialPageRoute(builder: (_) => const FilesPage());
    default:
      return MaterialPageRoute(builder: (_) => const LoadingPage());
  }
}
