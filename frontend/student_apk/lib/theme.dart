import 'package:flutter/material.dart';

class AppTheme {
  static const Color textColor = Color(0xFFF4EAFF); // Student Text Color
  static const Color textColor2 = Color(0xFF40005C); // Student Text Color 2
  static const Color buttonBg = Color(0xFFEDDCFF); // Student Buttons
  static const Color primaryColor =
      Color(0xFF4E0070); // Using the lighter gradient color as primary
  static const Color backgroundGradientStart =
      Color(0xFF4E0070); // Student BG Gradient light
  static const Color backgroundGradientEnd =
      Color(0xFF1B0027); // Student BG Gradient dark

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundGradientStart,
      backgroundGradientEnd,
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFF5F5F5),
    ],
  );

  // Helper methods to handle color opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  static Color withCustomAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }

  static ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.purple, // Changed to purple to match the theme
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColor),
        displayMedium: TextStyle(color: textColor),
        displaySmall: TextStyle(color: textColor),
        headlineMedium: TextStyle(color: textColor),
        headlineSmall: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
