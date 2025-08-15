import 'package:flutter/material.dart';
import '../theme.dart';

class TriangleLogo extends StatelessWidget {
  final double size;
  final bool isWhite;

  const TriangleLogo({
    Key? key,
    required this.size,
    this.isWhite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
          painter: TrianglePainter(
            color: isWhite ? Colors.white : AppTheme.primaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  TrianglePainter({
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Calculate triangle points for perfect equilateral triangle
    final height = size.height * 0.9; // Leave some padding
    final width = height * 1.1547; // width = height * 2/√3 for equilateral triangle

    final startX = (size.width - width) / 2;
    final startY = size.height * 0.05; // Top padding

    final path = Path();
    // Draw from top center
    path.moveTo(startX + width/2, startY);
    // To bottom right
    path.lineTo(startX + width, startY + height);
    // To bottom left
    path.lineTo(startX, startY + height);
    // Back to top
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) =>
    color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
