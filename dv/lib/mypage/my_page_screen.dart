import 'package:dv/menu/menu.dart';
import 'package:dv/menu/menu_provider.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String nickname = "nickname"; //유저 닉네임(입력받으면 바꿔야 함)
  int point = 0; //포인트 초기값 설정

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().changeMenu(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 8;
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "마이 페이지")),
      ),
      floatingActionButton: FloatingMenuButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  //위젯 크기 제약 조건 설정
                  minHeight: MediaQuery.of(context).size.width,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 100, top: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  size: imageSize,
                                  color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                          [3]
                                      .withAlpha(128),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorPalette.palette[
                                          themeProvider.selectedThemeIndex][3]),
                                  child: Text(
                                    languageProvider.getLanguage(message: "프로필 편집"),
                                    style: TextStyle(
                                        color: ColorPalette.palette[
                                            themeProvider
                                                .selectedThemeIndex][0]),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nickname,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      languageProvider.getLanguage(message: "보유 포인트"),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ColorPalette.palette[
                                            themeProvider.selectedThemeIndex][2],
                                      ),
                                    ),
                                    Text(
                                      " : $point pt",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ColorPalette.palette[
                                            themeProvider.selectedThemeIndex][2],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), //왼쪽 상단 정렬
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
