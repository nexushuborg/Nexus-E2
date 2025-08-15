// Custom theme for teacher_apk app
import 'package:flutter/material.dart';

class AppTheme {
  // Main color palette from Figma
  static const Color primaryColor = Color(0xFF55007A); // Text color
  static const Color backgroundGradientStart = Color(0xFFF4EAFF); // Light gradient
  static const Color backgroundGradientEnd = Color(0xFFB06BCE); // Dark gradient
  static const Color glassColor = Colors.white24;

  // ThemeData for consistent typography and colors
  static ThemeData get themeData => ThemeData(
    fontFamily: 'Montserrat',
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundGradientStart,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: primaryColor,
      surface: backgroundGradientStart,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  );
}
