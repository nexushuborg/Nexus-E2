import 'package:flutter/material.dart';
import 'screens/get_started_page.dart';
import 'screens/login.dart';
import 'screens/signup_step1_page.dart';
import 'screens/signup_step2_page.dart';
import 'screens/signup_step3_page.dart';
import 'screens/verification_complete_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';

class Routes {
  static const String getStarted = '/';
  static const String login = '/login';
  static const String signUpStep1 = '/signup/step1';
  static const String signUpStep2 = '/signup/step2';
  static const String signUpStep3 = '/signup/step3';
  static const String verification = '/verification';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String accountSettings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case getStarted:
        return MaterialPageRoute(builder: (_) => const GetStartedPage());
      case login:
        return MaterialPageRoute(builder: (_) => const ArcanumLogin());
      case signUpStep1:
        return MaterialPageRoute(builder: (_) => const SignUpStep1Page());
      case signUpStep2:
        return MaterialPageRoute(builder: (_) => const SignUpStep2Page());
      case signUpStep3:
        return MaterialPageRoute(builder: (_) => const SignUpStep3Page());
      case verification:
        return MaterialPageRoute(builder: (_) => const VerificationCompletePage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case accountSettings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
