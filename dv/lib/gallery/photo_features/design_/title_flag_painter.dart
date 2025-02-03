import 'package:flutter/material.dart';

class TitleFlagPainter extends CustomPainter {
  final Color fillColor;

  TitleFlagPainter({required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0) // 왼쪽 상단
      ..lineTo(size.width * 0.85, 0) // 직사각형 상단 끝
      ..lineTo(size.width, size.height * 0.5) // 삼각형 끝점 (오른쪽 중앙)
      ..lineTo(size.width * 0.85, size.height) // 직사각형 하단 끝
      ..lineTo(0, size.height) // 왼쪽 하단
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
