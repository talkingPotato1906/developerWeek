import 'package:dv/gallery/recommend/recommend_screen.dart';
import 'package:dv/gallery/recommend/recommendation_page.dart';
import 'package:flutter/material.dart';

import 'photo.dart'; // PhotoPage
import 'showroom.dart'; // ShowroomPage

class SwipePageView extends StatefulWidget {
  const SwipePageView({super.key});

  @override
  _SwipePageViewState createState() => _SwipePageViewState();
}

class _SwipePageViewState extends State<SwipePageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);

    /// ✅ setState를 사용해 초기 렌더링 후 `pageController` 안정화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {}); // 페이지 값이 안정화된 후 다시 렌더링
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSwipe(DragEndDetails details) {
    double velocity = details.primaryVelocity ?? 0;

    /// ✅ `null` 방지: `hasClients`가 `true`일 때만 페이지 값 확인
    if (!_pageController.hasClients || _pageController.page == null) return;

    int currentPage = _pageController.page!.round();

    if (velocity > 500) {
      // 오른쪽으로 스와이프 (이전 페이지로 이동)
      if (currentPage == 1) {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else if (currentPage == 2) {
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    } else if (velocity < -500) {
      // 왼쪽으로 스와이프 (다음 페이지로 이동)
      if (currentPage == 1) {
        _pageController.animateToPage(2,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else if (currentPage == 0) {
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: _onSwipe,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            RecommendScreen(), // 추천 페이지 (0)
            ShowroomPage(), // 전시대 (1) - 기본 페이지
            PhotoPage(), // 보관함 (2)
          ],
        ),
      ),
    );
  }
}
