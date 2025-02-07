import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPointsProvider with ChangeNotifier {
  int _points = 0; // 🔹 유저 포인트
  bool _isLoading = true; // 🔹 로딩 상태 추가
  String? _userId; // 현재 로그인한 유저 ID

  int get points => _points;
  bool get isLoading => _isLoading;

  // 🔹 Firestore에서 포인트 가져오기
  Future<void> fetchUserPoints() async {
    try {
      _isLoading = true; // 🔹 로딩 시작
      notifyListeners(); // UI 업데이트

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      _userId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        _points = userDoc["points"] ?? 0;
        print("🔥 현재 보유 포인트: $_points");
      } else {
        print("❌ 유저 데이터 없음");
      }
    } catch (e) {
      print("❌ 포인트 가져오기 실패: $e");
    } finally {
      _isLoading = false; // 🔹 로딩 완료
      notifyListeners(); // UI 업데이트
    }
  }
}
