import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

class GlassFrame extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const GlassFrame({
    super.key,
    required this.child,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.withOpacity(Colors.white, 0.1),
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.withOpacity(Colors.white, 0.1),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
