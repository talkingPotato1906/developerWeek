import 'package:dv/firebase_login/signup_login_screen.dart';
import 'package:dv/login/login_page.dart';
import 'package:dv/login/login_provider.dart';
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

    // 애니메이션 실행 후 로그인 상태 확인
    _controller.forward().then((_) => _navigateAfterAnimation());
  }

  Future<void> _navigateAfterAnimation() async {
    final loginProvider = context.read<LogInProvider>();
    await loginProvider.loadUserData(); // 로그인 데이터 불러오기

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        if (loginProvider.isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()), // 홈 화면 이동
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()), // 로그인 페이지 이동
          );
        }
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
              Text(
                languageProvider.getLanguage(message: "앱 제목"),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
