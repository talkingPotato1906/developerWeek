import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategory = "식물"; // ✅ 하나의 카테고리만 저장

  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category; // ✅ 기존 값을 대체
    notifyListeners();
  }
}

