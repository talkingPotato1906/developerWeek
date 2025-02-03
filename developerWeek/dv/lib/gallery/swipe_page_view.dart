import 'package:flutter/material.dart';

import 'photo.dart'; // PhotoPage
import 'showroom.dart'; // ShowroomPage

class SwipePageView extends StatelessWidget {
  const SwipePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! < 0) {
              if (pageController.page!.toInt() == 0) {
                pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            } else if (details.primaryDelta! > 0) {
              if (pageController.page!.toInt() == 1) {
                pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            }
          },
          child: PageView(
            controller: pageController,
            children: [
              ShowroomPage(), // 페이지 1: 전시대
              PhotoPage(), // 페이지 2: 보관함
            ],
          ),
        ),
      ),
    );
  }
}
