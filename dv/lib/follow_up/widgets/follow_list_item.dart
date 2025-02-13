import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';

class FollowListItem extends StatefulWidget {
  final String uid;

  const FollowListItem({super.key, required this.uid, required Color color});

  @override
  _FollowListItemState createState() => _FollowListItemState();
}

class _FollowListItemState extends State<FollowListItem> {
  String? name;
  String? profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 유저 데이터를 Firestore에서 가져오는 함수
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    if (uid.isEmpty) {
      debugPrint("UID가 비어있습니다.");
      return null;
    }

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = userDoc.data();
      if (userDoc.exists && data != null) {
        return data as Map<String, dynamic>;
      }
    } catch (e, stackTrace) {
      debugPrint("유저 데이터를 가져오는 중 오류 발생: $e");
      debugPrint("$stackTrace");
    }
    return null;
  }

  /// 유저 데이터를 로드하고 상태 업데이트
  Future<void> _loadUserData() async {
    final userData = await getUserData(widget.uid);
    if (mounted && userData != null) {
      setState(() {
        name = userData["nickname"];

        // profile 배열에서 0번 인덱스 값 가져오기
        final profileArray = userData["profile"];
        if (profileArray is List && profileArray.isNotEmpty) {
          profileImage = profileArray[0] is String
              ? profileArray[0]
              : "assets/profile/default.png";
        } else {
          profileImage = "assets/profile/default.png";
        }

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context);

    final isFollowing =
        followProvider.following.any((user) => user == widget.uid);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    // 팔로우 상태가 아니면 아무것도 표시하지 않음
    if (!isFollowing) {
      return SizedBox.shrink();
    }

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListTile(
            leading: CircleAvatar(
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : AssetImage("assets/profile/default.png") as ImageProvider,
            ),
            title: Text(name ?? "Unknown User"),
            trailing: ElevatedButton(
              onPressed: () {
                followProvider.unfollow(widget.uid);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                languageProvider.getLanguage(message: "언팔로우"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
