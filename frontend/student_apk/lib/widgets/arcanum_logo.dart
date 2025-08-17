import 'package:flutter/material.dart';
import 'package:student_apk/widgets/triangle_logo.dart';

class ArcanumLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const ArcanumLogo({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TriangleLogo(size: size, color: logoColor),
        const SizedBox(height: 16),
        Text(
          'ΔRCANUM',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: logoColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Learn smarter. Manage faster.',
          style: TextStyle(
            fontSize: size * 0.2,
            color: logoColor,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
