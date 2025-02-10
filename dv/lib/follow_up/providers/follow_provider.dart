import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowProvider with ChangeNotifier {
  List<Map<String, String>> _following = [];

  List<Map<String, String>> get following => _following;

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
      List<String> followingUids =
          List<String>.from(userDoc["following"] ?? []);

      List<Map<String, String>> followingList = [];

      for (String uid in followingUids) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          followingList.add({
            "name": userData["nickname"] ?? "Unknown",
            "profileImage": userData["profile"] != null &&
                    (userData["profile"] as List).isNotEmpty
                ? userData["profile"][userData["profileIdx"] ?? 0]
                : "https://example.com/default_profile.jpg",
            "uid": uid,
          });
        }
      }

      _following = followingList;
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

    // 팔로우한 유저의 정보 가져오기
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      _following.add({
        "name": userData["nickname"] ?? "Unknown",
        "profileImage": userData["profile"] != null &&
                (userData["profile"] as List).isNotEmpty
            ? userData["profile"][userData["profileIdx"] ?? 0]
            : "https://example.com/default_profile.jpg",
        "uid": uid,
      });
      notifyListeners();
    }
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

    _following.removeWhere((user) => user["uid"] == uid);
    notifyListeners();
  }
}
