import 'package:dv/login/login_provider.dart'; //로그인 파트
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/title/title_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gallery/image_provider.dart'; // image_provider.dart
import 'gallery/swipe_page_view.dart'; // 새로 만든 swipe_page_view.dart

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageProviderClass()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => LogInProvider()), //로그인파트 추가
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ThemeProvider>(context, listen: false).loadTheme(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: ImageFadeInAnimation(),
            );
          }

          return Consumer<ThemeProvider>(
              builder: (context, ThemeProvider themeProvider, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: themeProvider.getTheme(),
              home: ImageFadeInAnimation(),
            );
          });
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SwipePageView(), // 화면 좌우이동 기능
          FloatingMenuButton(),
        ],
      ),
    );
  }
}
