import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dv/main.dart'; // 홈 화면이 있는 main.dart 파일 import

class ImageRiseAnimation extends StatefulWidget {
  @override
  ImageRiseAnimationState createState() => ImageRiseAnimationState();
}

class ImageRiseAnimationState extends State<ImageRiseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _bounceAnimation;
  double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          screenHeight = MediaQuery.of(context).size.height;
          double startPosition = screenHeight + 80;
          double endPosition = (screenHeight / 2) - 50;

          _positionAnimation = Tween<double>(begin: startPosition, end: endPosition).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          );

          _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          );

          _controller.forward().then((_) {
            // 애니메이션이 끝난 후 홈 화면으로 전환
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()), // main.dart의 홈 화면
            );
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (screenHeight == 0.0) {
      return Scaffold(
        backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 터치 방지용 오버레이
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _controller.isAnimating, // 애니메이션 중에는 터치 방지
              child: Container(color: Colors.transparent),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _positionAnimation.value + _bounceAnimation.value,
                child: Opacity(
                  opacity: _controller.value,
                  child: Image.asset(
                    'assets/title/logo.png',
                    width: 150,
                    height: 150,
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
