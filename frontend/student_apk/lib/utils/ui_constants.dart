import 'package:flutter/material.dart';

class UIConstants {
  // Colors
  static const Color textColor = Colors.white;
  static const Color textColor2 = Color(0xFF2D2D2D);
  static const Color buttonColor = Color(0xFF6B42DD);
  static const Color buttonBg = Color(0xFF6B42DD);
  static const Color backgroundGradientStart = Color(0xFF6B42DD);
  static const Color backgroundGradientEnd = Color(0xFF9747FF);
  static const Color primaryColor = buttonColor;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Border Radius
  static const double glassRadius = 32.0;
  static const double inputRadius = 32.0;
  static const double buttonRadius = 32.0;

  // Text Styles
  static const TextStyle bodyStyle = TextStyle(color: textColor2, fontSize: 16);
  static const TextStyle headingStyle = TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold);

  // Glass Effect Decoration
  static BoxDecoration glassDecoration() {
    return BoxDecoration(
      color: Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(glassRadius),
      border: Border.all(
        color: Colors.white.withAlpha(51),
        width: 1.5,
      ),
    );
  }

  static BorderRadius circularRadius(double radius) {
    return BorderRadius.circular(radius);
  }

  // Gradient
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundGradientStart,
      backgroundGradientEnd,
    ],
  );
}
