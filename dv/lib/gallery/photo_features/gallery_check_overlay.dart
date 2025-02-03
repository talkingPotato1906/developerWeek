import 'package:flutter/material.dart';

class GalleryCheckOverlay extends StatelessWidget {
  final bool isSelected;

  const GalleryCheckOverlay({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return SizedBox(); // 갤러리에 추가되지 않은 경우 빈 위젯 반환

    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01, // 퍼센트 단위로 조정
      left: MediaQuery.of(context).size.width * 0.02,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.green, // ✅ 체크 아이콘 배경색
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: MediaQuery.of(context).size.width * 0.05, // ✅ 크기 퍼센트 단위로 조정
        ),
      ),
    );
  }
}
