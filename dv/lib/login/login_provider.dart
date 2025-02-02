import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  String get email => _email;

  LogInProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('email') ?? '';
    notifyListeners();
  }

  Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    _email = email;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _email = '';
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    notifyListeners();
  }
}
