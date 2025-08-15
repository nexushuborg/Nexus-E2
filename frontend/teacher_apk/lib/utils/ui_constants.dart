// Shared UI constants for consistent styling
import 'package:flutter/material.dart';

class UIConstants {
  // Button styling
  static const double buttonHeight = 56.0;
  static const double buttonRadius = 32.0;
  static const double inputRadius = 32.0;

  // Glass effect constants
  static const double glassOpacity = 0.2;
  static const double glassRadius = 24.0;

  // Icon sizes
  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Avatar sizes
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 80.0;
  static const double avatarSizeLarge = 120.0;

  // Border radius
  static BorderRadius circularRadius(double radius) => BorderRadius.circular(radius);

  // Glass decoration
  static BoxDecoration glassDecoration({
    double opacity = glassOpacity,
    double radius = glassRadius,
    Color? color,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: circularRadius(radius),
    );
  }
}
