import 'package:flutter/material.dart';

class ArcanumLogo extends StatelessWidget {
  final Color color;
  final double fontSize;
  final bool whiteTriangle;

  const ArcanumLogo({
    super.key,
    required this.color,
    this.fontSize = 20,
    this.whiteTriangle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Triangle for 'A'
        SizedBox(
          width: fontSize * 0.7,
          height: fontSize,
          child: CustomPaint(
            painter: TrianglePainter(
              color: whiteTriangle ? Colors.white : color,
              strokeWidth: fontSize * 0.04,
            ),
          ),
        ),
        SizedBox(width: fontSize * 0.15), // Space after triangle
        // RCANUM text
        Text(
          'RCANUM',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w200,
            letterSpacing: fontSize * 0.1,
            color: color,
            fontFamily: 'Montserrat',
            height: 1,
          ),
        ),
      ],
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

    final path = Path();
    // Create an equilateral triangle
    final triangleHeight = size.height * 0.9;
    final triangleWidth = triangleHeight * 0.866; // width = height * tan(60°)

    final startX = (size.width - triangleWidth) / 2;
    final startY = size.height * 0.05; // Small top padding

    path.moveTo(startX + triangleWidth/2, startY); // Top point
    path.lineTo(startX + triangleWidth, startY + triangleHeight); // Bottom right
    path.lineTo(startX, startY + triangleHeight); // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
