import 'package:flutter/material.dart';
import 'package:student_apk/widgets/triangle_painter.dart';

class TriangleLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const TriangleLogo({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: TrianglePainter(
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
