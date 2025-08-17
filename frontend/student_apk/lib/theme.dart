import 'package:flutter/material.dart';
import 'utils/ui_constants.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = UIConstants.primaryColor;
  static const Color secondaryColor = UIConstants.backgroundGradientEnd;

  // Background Colors
  static const Color backgroundGradientStart = Color(0xFF4E0070);
  static const Color backgroundGradientEnd = Color(0xFF1B0027);

  // Static Theme Data
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
  );

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );
  static const Color textColor = Color(0xFFF4EAFF);
  static const Color textColor2 = Color(0xFF40005C);
  static const Color buttonBg = Color(0xFFEDDCFF);
}
