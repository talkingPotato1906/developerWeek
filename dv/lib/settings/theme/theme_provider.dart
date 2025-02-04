//  테마 변환 Provider
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/shelves_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  int _selectedThemeIndex = 0; // 기본값은 식물 테마

  int get selectedThemeIndex => _selectedThemeIndex;

  // 생성자
  ThemeProvider() {
    loadTheme();
  }

  // 테마 변경 및 즉시 반영
  Future<void> changeTheme(int index) async {
    _selectedThemeIndex = index;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedThemeIndex", index);
  }

  // 테마 로드
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedThemeIndex = prefs.getInt("selectedThemeIndex") ?? 0;
    notifyListeners();
  }

  // 테마 색상 반환
  ThemeData getTheme() {
    Color textColor = ColorPalette.palette[_selectedThemeIndex][3];
    Color buttonColor = ColorPalette.palette[_selectedThemeIndex][0];

    return ThemeData(
        colorScheme: ColorScheme.light(
          primary: ColorPalette.palette[_selectedThemeIndex][0]
              .withValues(alpha: 128),
          secondary: ColorPalette.palette[_selectedThemeIndex][1]
              .withValues(alpha: 128),
        ),
        scaffoldBackgroundColor: ColorPalette.palette[_selectedThemeIndex][0],  //  배경색
        //  글자색
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
          titleLarge: TextStyle(color: textColor),
          titleMedium: TextStyle(color: textColor),
          titleSmall: TextStyle(color: textColor),
          labelLarge: TextStyle(color: buttonColor),
          labelMedium: TextStyle(color: buttonColor),
          labelSmall: TextStyle(color: buttonColor),
        ),
        useMaterial3: true);
  }

  String getCutlery() {
    return ShelvesList.shelvesList["식기"]![0];
  }
}
