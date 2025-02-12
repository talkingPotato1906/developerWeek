import 'package:dv/gallery/recommendation_page.dart';
import 'package:flutter/material.dart';

import 'photo.dart'; // PhotoPage
import 'showroom.dart'; // ShowroomPage

class SwipePageView extends StatelessWidget {
  const SwipePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: 1); // ✅ 초기 페이지를 전시대(1)로 설정

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // 왼쪽에서 오른쪽으로 스와이프
            if (pageController.page!.toInt() == 1) {
              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut); // 추천 페이지로 이동
            } else if (pageController.page!.toInt() == 2) {
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut); // 전시대로 복귀
            }
          } else if (details.primaryDelta! < 0) {
            // 오른쪽에서 왼쪽으로 스와이프
            if (pageController.page!.toInt() == 1) {
              pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut); // 보관함으로 이동
            } else if (pageController.page!.toInt() == 0) {
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut); // 전시대로 복귀
            }
          }
        },
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(), // 스와이프로만 이동 허용
          children: [
            RecommendationPage(), // 페이지 0: 추천 페이지
            ShowroomPage(), // 페이지 1: 전시대 (기본 페이지)
            PhotoPage(), // 페이지 2: 보관함
          ],
        ),
      ),
    );
  }
}
