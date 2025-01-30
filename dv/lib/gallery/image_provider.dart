//provider를 이용해 이미지를 관리하는 파일

import 'package:flutter/material.dart';

class ImageProviderClass with ChangeNotifier {
  final List<Map<String, dynamic>> _images = [];

  List<Map<String, dynamic>> get images => _images;

  // 이미지와 제목, 내용을 추가하는 함수
  void addImage(Map<String, dynamic> imageData) {
    _images.add(imageData);
    notifyListeners();
  }

  // 이미지를 지우는 함수
  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }
}
