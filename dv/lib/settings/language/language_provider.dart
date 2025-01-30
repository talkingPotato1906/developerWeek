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

  List<String> getLanguage(){
    return LanguageList.languageMessages[_selectedLanguageIndex];
  }
}