import 'package:flutter/material.dart';

import 'title_flag_painter.dart'; // ✅ 깃발을 그리는 TitleFlagPainter 추가

class TitleFlag extends StatelessWidget {
  final String title;

  const TitleFlag({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // ✅ 창의 60% 차지
          height: 50,
          child: CustomPaint(
            painter: TitleFlagPainter(
                fillColor: Colors.blue), // ✅ TitleFlagPainter 적용
          ),
        ),
        Positioned(
          left: 20, // ✅ 제목 위치 조정
          top: 10,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // ✅ 텍스트 색상을 흰색으로 변경
            ),
          ),
        ),
      ],
    );
  }
}
