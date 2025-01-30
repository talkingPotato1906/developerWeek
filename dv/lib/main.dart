import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/title/title_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gallery/showroom.dart'; // showroom.dart 전시대
import 'gallery/photo.dart'; // photo.dart 보관함
import 'gallery/image_provider.dart'; // image_provider.dart

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageProviderClass()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
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
            home: ImageRiseAnimation(),
          );
        }

        return Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themeProvider, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              // 테마 변경 사항 적용
              theme: themeProvider.getTheme(),
              home: const MyHomePage(title: 'Flutter Demo Home Page'),
            );
          }
        );
      }
    );
      
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final PageController _pageController = PageController(initialPage: 0);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        
        children: [GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! < 0) {
              if (_pageController.page!.toInt() == 0) {
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            } else if (details.primaryDelta! > 0) {
              if (_pageController.page!.toInt() == 1) {
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            }
          },
          child: PageView(
            controller: _pageController,
            children: [
              ShowroomPage(), // 페이지 1: 전시대
              PhotoPage(), // 페이지 2: 보관함
            ],
          ),
        ),
        FloatingMenuButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
