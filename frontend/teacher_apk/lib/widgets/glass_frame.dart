// GlassFrame widget for glassmorphism effect
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassFrame extends StatelessWidget {
  // Child widget to display inside the glass frame
  final Widget child;
  // Border radius for rounded corners
  final double borderRadius;
  // Blur amount for glass effect
  final double blur;
  // Padding inside the frame
  final EdgeInsetsGeometry? padding;
  // Optional custom color for the frame
  final Color? color;

  const GlassFrame({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 16,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use ClipRRect and BackdropFilter for glassmorphism
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withAlpha(46), // 0.18 * 255 = 46
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withAlpha(51)), // 0.2 * 255 = 51
          ),
          child: child,
        ),
      ),
    );
  }
}
