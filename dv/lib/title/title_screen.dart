import 'package:dv/color_palette.dart';
import 'package:flutter/material.dart';

// 테스트용 메인 함수. 실제 앱에서는 사용하지 않음(main.dart에서 실행)
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,  // 디버그 배너 제거
    home: ImageRiseAnimation(),
  ));
}

// 앱 로고가 위로 올라가는 애니메이션
class ImageRiseAnimation extends StatefulWidget {
  @override
  ImageRiseAnimationState createState() => ImageRiseAnimationState();
}

class ImageRiseAnimationState extends State<ImageRiseAnimation>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러와 애니메이션 변수 선언
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _bounceAnimation;
  double screenHeight = 0.0; // 화면 높이 저장

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // 2초 동안 실행
    );

    // 애니메이션 실행 (딜레이 추가)
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          screenHeight = MediaQuery.of(context).size.height;  // 화면 높이 가져오기
          double startPosition = screenHeight + 80; // 화면 아래에서 시작
          double endPosition = (screenHeight / 2) - 50; // 중앙에 도착 (이미지 높이 고려)

          // 시작과 끝 위치를 지정한 애니메이션
          _positionAnimation = Tween<double>(begin: startPosition, end: endPosition).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          );

          // 튀는 효과를 주는 애니메이션
          _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          );

          // 애니메이션 시작
          _controller.forward();
        });
      }
    });
  }

  // 앱 종료 시 애니메이션 컨트롤러 해제
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (screenHeight == 0.0) {
      return Scaffold(
        backgroundColor: ColorPalette.palette[0][0],  // 배경색 color_palette.dart에서 가져오기
        body: Center(child: CircularProgressIndicator()), // 높이를 가져올 때까지 로딩 표시
      );
    }

    return Scaffold(
      backgroundColor: ColorPalette.palette[0][0],  // 배경색 color_palette.dart에서 가져오기
      body: Stack(
        alignment: Alignment.center,  // 중앙 정렬
        children: [
          // 이미지 애니메이션
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _positionAnimation.value + _bounceAnimation.value, // 마지막 튀는 효과 추가
                child: Opacity(
                  opacity: _controller.value,
                  child: Image.asset(
                    'assets/title/logo.png', // 사용할 이미지 경로
                    width: 150, // 크기 고정
                    height: 150, // 크기 고정
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



