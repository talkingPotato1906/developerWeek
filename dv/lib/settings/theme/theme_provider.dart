import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  int _selectedThemeIndex = 0; // 선택된 테마 인덱스

  int get selectedThemeIndex => _selectedThemeIndex;

  void changeTheme(int index) {
    
    _selectedThemeIndex = index;
    notifyListeners();
  }
}