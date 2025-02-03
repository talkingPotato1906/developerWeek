import 'package:flutter/material.dart';

class ImageProviderClass with ChangeNotifier {
  final List<Map<String, dynamic>> _images = [];
  final List<Map<String, dynamic>> _selectedImages = []; // 선택된 이미지 리스트

  List<Map<String, dynamic>> get images => _images;
  List<Map<String, dynamic>> get selectedImages => _selectedImages;

  void addImage(Map<String, dynamic> imageData) {
    _images.add(imageData);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      final removedImage = _images[index]; // 삭제할 이미지 데이터 저장

      _images.removeAt(index); // ✅ 전체 이미지 목록에서 삭제
      _selectedImages.remove(removedImage); // ✅ 전시대에서도 삭제 반영

      notifyListeners(); // UI 업데이트
    }
  }

  void toggleGalleryImage(Map<String, dynamic> imageData) {
    if (_selectedImages.contains(imageData)) {
      _selectedImages.remove(imageData);
    } else {
      if (_selectedImages.length < 9) {
        _selectedImages.add(imageData);
      }
    }
    notifyListeners();
  }

  // ✅ 이미지 제목 및 내용 수정 기능 추가
  void updateImage(int index, String newTitle, String newContent) {
    if (index >= 0 && index < _images.length) {
      _images[index] = {
        "image": _images[index]["image"], // 기존 이미지 유지
        "title": newTitle, // 새로운 제목
        "content": newContent, // 새로운 내용
      };
      notifyListeners(); // UI 갱신
    }
  }
}
