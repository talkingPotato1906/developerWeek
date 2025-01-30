import 'package:dv/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  int _selectedThemeIndex = 0; // 선택된 테마 인덱스

  int get selectedThemeIndex => _selectedThemeIndex;

  //  앱 시작 시 테마 불러오기
  ThemeProvider() {
    loadTheme();
  }

  //  테마 변경 및 저장
  Future<void> changeTheme(int index) async {
    _selectedThemeIndex = index;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedThemeIndex", index);
  }

  // 앱 시작 시 저장된 테마 불러오기
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedThemeIndex = prefs.getInt("selectedThemeIndex") ?? 0;
    notifyListeners();
  }

  // 테마 색상 반환
  ThemeData getTheme() {
    return ThemeData(
        colorScheme: ColorScheme.light(
          primary: ColorPalette.palette[_selectedThemeIndex][1],
          secondary: ColorPalette.palette[_selectedThemeIndex][2],
        ),
        scaffoldBackgroundColor: ColorPalette.palette[_selectedThemeIndex][0],
        useMaterial3: true);
  }
}
