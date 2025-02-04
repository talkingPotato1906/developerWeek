//팔로우 데이터 관리
import 'package:flutter/material.dart';

class FollowProvider with ChangeNotifier {
  final List<Map<String, String>> _following = [
    {"name": "홍길동", "profileImage": "https://example.com/profile1.jpg"},
    {"name": "김철수", "profileImage": "https://example.com/profile2.jpg"},
    {"name": "이영희", "profileImage": "https://example.com/profile3.jpg"},
  ];

  List<Map<String, String>> get following => _following;

  void unfollow(String name) {
    _following.removeWhere((user) => user["name"] == name);
    notifyListeners();
  }
}
