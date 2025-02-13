import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowProvider with ChangeNotifier {
  List<String> _following = [];

  List<String> get following => _following;

  FollowProvider() {
    _fetchFollowing();
  }

  // Firestore에서 following 목록 가져오기
  Future<void> _fetchFollowing() async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .get();

    if (userDoc.exists) {
      _following = List<String>.from(userDoc["following"] ?? []);
      notifyListeners();
    }
  }

  Future<void> follow(String uid) async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    // Firestore에 새로운 팔로우 추가
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .update({
      "following": FieldValue.arrayUnion([uid])
    });

    _following.add(uid);
    notifyListeners();
  }

  // 언팔로우 기능 (Firestore 업데이트)
  Future<void> unfollow(String uid) async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .update({
      "following": FieldValue.arrayRemove([uid])
    });

    _following.remove(uid);
    notifyListeners();
  }
}
