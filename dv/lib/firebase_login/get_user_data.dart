import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserData with ChangeNotifier {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  Future<void> getUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid; // 현재 로그인한 사용자 UID
      print("UID: $uid");
      
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
        print("유저 데이터: $userData");
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
}
