import 'package:dv/settings/language/language_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier{
  int _selectedLanguageIndex = 0;

  int get selectedLanguageIndex => _selectedLanguageIndex;

  LanguageProvider(){
    loadLanguage();
  }

  Future<void> changeLanguage(int index) async{
    _selectedLanguageIndex = index;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedLanguageIndex", index);
  }

  Future<void> loadLanguage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLanguageIndex = prefs.getInt("selectedLanguageIndex") ?? 0;
    notifyListeners();
  }

  String getLanguage({required String? message}){
    if (message == null || !LanguageList.languageMessages.containsKey(message)) {
      return message ?? "Unknown"; // Fallback value if message is null or not found
    }

    List<String> translations = LanguageList.languageMessages[message] ?? [];
    if (_selectedLanguageIndex >= translations.length) {
      return translations.isNotEmpty ? translations[0] : "Unknown"; // Fallback to default language
    }

    return translations[_selectedLanguageIndex];
  }
}