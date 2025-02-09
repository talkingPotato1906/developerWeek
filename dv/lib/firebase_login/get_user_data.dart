import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserData with ChangeNotifier {
  Map<String, dynamic> userData = {};
  int points = 0; // 🔹 Firestore의 포인트 값 저장 (초기값 0)
  bool isLoading = true;

  // 🔹 Firestore에서 유저 데이터 가져오기 (포인트 포함)
  Future<void> getUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? ""; // 🔹 로그인 확인
      if (uid.isEmpty) return;

      print("UID: $uid");

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;

        // 🔹 Firestore에서 포인트 값 가져오기 (기본값 0)
        points = userData["points"] ?? 0;

        print("유저 데이터: $userData");
        print("보유 포인트: $points"); // 디버깅 로그 추가
      } else {
        print("유저 데이터 없음");
      }
    } catch (e) {
      print("데이터 가져오기 실패: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Firestore에서 포인트 업데이트
  Future<void> updateUserPoints(int newPoints) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      if (uid.isEmpty) return;

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "points": newPoints, // 🔹 Firestore의 "points" 필드 업데이트
      });

      points = newPoints; // 🔹 로컬 변수도 업데이트
      notifyListeners();
      print("포인트 업데이트 완료: $points");
    } catch (e) {
      print("포인트 업데이트 실패: $e");
    }
  }

  // 🔹 기존 닉네임 업데이트 기능 유지
  Future<void> updateNickname(String newNickname) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      if (uid.isEmpty) return;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"nickname": newNickname});

      userData["nickname"] = newNickname;
      notifyListeners();
    } catch (e) {
      print("닉네임 업데이트 실패: $e");
    }
  }

  // 프로필 업데이트 기능
  Future<void> updateProfile(int newProfileIndex) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      if (uid.isEmpty) return;

      await FirebaseFirestore.instance.collection("users").doc(uid).update({"profileIdx": newProfileIndex});

      userData["profileIdx"] = newProfileIndex;
      notifyListeners();
    } catch (e) {
      print("프로필 인덱스 업데이트 실패: $e");
    }
  }
}
