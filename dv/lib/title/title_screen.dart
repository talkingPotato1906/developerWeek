import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dv/main.dart'; // 홈 화면 import

class ImageFadeInAnimation extends StatefulWidget {
  @override
  ImageFadeInAnimationState createState() => ImageFadeInAnimationState();
}

class ImageFadeInAnimationState extends State<ImageFadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // 2초 동안 페이드 인
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.forward().then((_) {
          // 애니메이션이 끝나면 홈 화면으로 전환
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()), // main.dart의 홈 화면
          );
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
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, // 서서히 나타나는 효과
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/title/logo.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(languageProvider.getLanguage(message: "앱 제목"),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

