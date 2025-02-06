import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeImages {
  // 테마별 이미지 리스트
  static const List<String> images = [
    "assets/login/green.png", // 식물 테마
    "assets/login/brown.png", // 식기 테마
    "assets/login/wine.png", // 주류 테마
    "assets/login/purple.png" // 원석 테마
  ];

  // 선택된 테마에 맞는 이미지 경로 반환
  static String getImage(int themeIndex) {
    return images[themeIndex % images.length]; // 인덱스 초과 방지
  }
}

// 🔹 테마에 따른 이미지 위젯
class ThemedImageWidget extends StatelessWidget {
  final double padding;

  const ThemedImageWidget({super.key, this.padding = 16.0});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeImage = ThemeImages.getImage(themeProvider.selectedThemeIndex);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Image.asset(themeImage, fit: BoxFit.contain),
    );
  }
}
