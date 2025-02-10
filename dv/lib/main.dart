import 'package:dv/firebase_login/get_user_data.dart';
import 'package:dv/firebase_login/signup_login.dart';
import 'package:dv/follow_up/providers/follow_provider.dart';
import 'package:dv/login/login_provider.dart'; //로그인 파트
import 'package:dv/menu/menu.dart';
import 'package:dv/nickname/nickname_provider.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/shop/shop_provider.dart';
import 'package:dv/shop/user_points_provider.dart';
import 'package:dv/title/title_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gallery/image_provider.dart'; // image_provider.dart
import 'gallery/swipe_page_view.dart'; // 새로 만든 swipe_page_view.dart

const firebaseConfig = {
  "apiKey": "AIzaSyDoTbJ2OukNUp_lz0l3uBwjyG6ESdrna6c",
  "authDomain": "talkingpotato-e4901.firebaseapp.com",
  "projectId": "talkingpotato-e4901",
  "storageBucket": "talkingpotato-e4901.firebasestorage.app",
  "messagingSenderId": "360743590694",
  "appId": "1:360743590694:web:386ece6c89cc8c0614bfe7",
  "measurementId": "G-JRF6ZBCZTJ"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: firebaseConfig["apiKey"]!,
          appId: firebaseConfig["appId"]!,
          messagingSenderId: firebaseConfig["messagingSenderId"]!,
          projectId: firebaseConfig["projectId"]!,
          authDomain: firebaseConfig["authDomain"]!,
          storageBucket: firebaseConfig["storageBucket"]!,
          measurementId: firebaseConfig["measurementId"]!));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FollowProvider()), // 팔로잉목록파트
        ChangeNotifierProvider(create: (context) => ImageProviderClass()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => LogInProvider()), //로그인파트 추가
        ChangeNotifierProvider(
            create: (context) => UserPointsProvider()), // ✅ 포인트 관리 Provider 등록
        ChangeNotifierProvider(
          create: (context) => ShopItemProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NicknameProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetUserData(),
        ),
        ChangeNotifierProvider(create: (context) => FollowProvider(),)
      ],
      child: const MyApp(),
    ),
  );
  debugPrint("Firebase Initialized");
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
      body: SwipePageView(),
      floatingActionButton: // 화면 좌우이동 기능
          FloatingMenuButton(),
    );
  }
}
