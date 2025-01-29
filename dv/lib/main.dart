import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gallery/showroom.dart'; // showroom.dart 전시대
import 'gallery/photo.dart'; // photo.dart 보관함
import 'gallery/image_provider.dart'; // image_provider.dart

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ImageProviderClass(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      body: GestureDetector(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
