import 'package:flutter/material.dart';

class LogoTrianglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool filled;

  LogoTrianglePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.filled = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double padding = size.width * 0.1;
    final double width = size.width - (padding * 2);
    final double height = width * 0.866; // height = width * sin(60°)

    final path = Path();
    path.moveTo(padding + width/2, padding);  // Top vertex
    path.lineTo(size.width - padding, height + padding);  // Bottom right
    path.lineTo(padding, height + padding);  // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LogoTrianglePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      filled != oldDelegate.filled;
}
