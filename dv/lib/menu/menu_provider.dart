import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuProvider extends ChangeNotifier {
  int _selectedMenuIndex = 0;

  int get selectedMenuIndex => _selectedMenuIndex;

  MenuProvider() {
    loadMenu();
  }

  Future<void> changeMenu(int index) async {
    _selectedMenuIndex = index;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedMenuIndex", index);
  }

  Future<void> loadMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedMenuIndex = prefs.getInt("selectedMenuIndex") ?? 0;
    notifyListeners();
  }

  int getMenu() {
    return _selectedMenuIndex;
  }
}
