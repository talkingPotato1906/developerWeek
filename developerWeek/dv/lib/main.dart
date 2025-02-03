import 'package:dv/login/login_provider.dart'; //로그인 파트
import 'package:dv/menu/menu.dart';
import 'package:dv/nickname/nickname_provider.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/shop/shop_provider.dart';
import 'package:dv/title/title_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'authentication/signup.dart'; // 회원가입 화면 추가
import 'gallery/image_provider.dart'; // image_provider.dart
import 'gallery/swipe_page_view.dart'; // 새로 만든 swipe_page_view.dart

void main() {
  //api 기본 설정
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageProviderClass()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => LogInProvider()), //로그인파트 추가
        ChangeNotifierProvider(
          create: (context) => ShopItemProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NicknameProvider(),
        )
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
            return GetMaterialApp(
              home: ImageFadeInAnimation(),
            );
          }

          return Consumer<ThemeProvider>(
              builder: (context, ThemeProvider themeProvider, child) {
            return GetMaterialApp(
              title: 'Flutter Demo',
              theme: themeProvider.getTheme(),
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => ImageFadeInAnimation()),
                GetPage(name: '/signup', page: () => SignUpScreen()), // 회원가입 화면 추가
              ],
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
      body: SwipePageView(),
      floatingActionButton: FloatingMenuButton(),
    );
  }
}
