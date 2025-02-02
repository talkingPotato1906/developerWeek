// 언어 변환 Provider
import 'package:dv/settings/language/language_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  int _selectedLanguageIndex = 0; //  기본 값을 영어로 설정

  int get selectedLanguageIndex => _selectedLanguageIndex;

  //  생성자자
  LanguageProvider() {
    loadLanguage();
  }

  //  언어 변환
  Future<void> changeLanguage(int index) async {
    _selectedLanguageIndex = index;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedLanguageIndex", index);
  }

  //  초기 실행 시 저장되어 있는 언어 불러오기
  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLanguageIndex = prefs.getInt("selectedLanguageIndex") ?? 0;
    notifyListeners();
  }

  //  각 메시지 별 언어 변환 기능
  String getLanguage({required String? message}) {
    if (message == null ||
        !LanguageList.languageMessages.containsKey(message)) {
      return message ??
          "Unknown"; // Fallback value if message is null or not found
    }

    // language_list.dart에 저장된 languageMessages 맵에서 message 불러오기
    List<String> translations = LanguageList.languageMessages[message] ?? [];
    if (_selectedLanguageIndex >= translations.length) {
      return translations.isNotEmpty
          ? translations[0]
          : "Unknown"; // Fallback to default language
    }
    
    // 메시지를 정해진 언어의 문자열로 반환
    return translations[_selectedLanguageIndex];
  }
}
