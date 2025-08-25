import 'package:flutter/material.dart';
import 'screens/get_started_page.dart';
import 'screens/login.dart';
import 'screens/sign_up_pages/signup_step1_page.dart';
import 'screens/sign_up_pages/signup_step2_page.dart';
import 'screens/sign_up_pages/signup_step3_page.dart';
import 'screens/sign_up_pages/verification_complete_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/forgot_pass_pages/forgot_password_email.dart';
import 'screens/forgot_pass_pages/forgot_password_otp.dart';
import 'screens/forgot_pass_pages/new_password.dart';

class Routes {
  static const String loading = 'loading';
  static const String getStarted = 'getStarted';
  static const String login = 'login';
  static const String signUpStep1 = 'signupStep1';
  static const String signUpStep2 = 'signupStep2';
  static const String signUpStep3 = 'signupStep3';
  static const String verification = 'verificationComplete';
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String forgotPasswordEmail = 'forgotPasswordEmail';
  static const String forgotPasswordOTP = 'forgotPasswordOTP';
  static const String newPassword = 'newPassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'getStarted':
        return MaterialPageRoute(builder: (_) => const GetStartedPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const ArcanumLogin());
      case 'signupStep1':
        return MaterialPageRoute(builder: (_) => const SignUpStep1Page());
      case 'signupStep2':
        return MaterialPageRoute(builder: (_) => const SignUpStep2Page());
      case 'signupStep3':
        return MaterialPageRoute(builder: (_) => const SignUpStep3Page());
      case 'verificationComplete':
        return MaterialPageRoute(builder: (_) => const VerificationCompletePage());
      case 'dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case 'profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case 'settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case 'forgotPasswordEmail':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordEmailScreen());
      case 'forgotPasswordOTP':
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
      case 'newPassword':
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());
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
