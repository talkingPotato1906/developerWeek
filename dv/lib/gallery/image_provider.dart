import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageProviderClass with ChangeNotifier {
  final List<Map<String, dynamic>> _images = [];
  final List<Map<String, dynamic>> _selectedImages = []; // 선택된 이미지 리스트

  List<Map<String, dynamic>> get images => _images;
  List<Map<String, dynamic>> get selectedImages => _selectedImages;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> fetchUserPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = _auth.currentUser!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        List<dynamic> postIds = userDoc["posts"] ?? [];

        _images.clear();
        for (String postId in postIds) {
          DocumentSnapshot postDoc =
              await _firestore.collection("posts").doc(postId).get();
          if (postDoc.exists && postDoc.data() != null) {
            Map<String, dynamic> postData =
                postDoc.data() as Map<String, dynamic>;

            _images.add({
              "imageUrl": postData["imageUrl"],
              "title": postData["title"],
              "content": postData["content"],
              "postId": postId,
            });
          }
        }
      }

      notifyListeners();
    } catch (e) {
      print("Firestore에서 posts 가져오기 실패");
    }

    isLoading = false;
    notifyListeners();
  }

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

  void updateImage(int index, String newTitle, String newContent) {
    if (index >= 0 && index < _images.length) {
      // 기존 이미지를 수정
      final updatedImage = {
        "image": _images[index]["image"], // 기존 이미지 유지
        "title": newTitle, // 새로운 제목
        "content": newContent, // 새로운 내용
      };

      _images[index] = updatedImage;

      // ✅ 갤러리에 추가된 이미지도 같이 업데이트
      for (int i = 0; i < _selectedImages.length; i++) {
        if (_selectedImages[i]["image"] == _images[index]["image"]) {
          _selectedImages[i] = updatedImage;
        }
      }

      notifyListeners(); // UI 갱신
    }
  }
}
