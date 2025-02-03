//  설정 화면
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_changer.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_changer.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    //  뒤로가기 눌렀을 때 /mypage/my_page_screen.dart 에서 감지
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(languageProvider.getLanguage(message: "설정")), // 설정 제목
        ),
        floatingActionButton: FloatingMenuButton(), // 메뉴 버튼
        body: Container(
            color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ThemeChanger(), //  테마 변경 위젯
                  LanguageChanger() // 언어 변경 위젯
                ],
              ),
            )),
      ),
    );
  }
}
