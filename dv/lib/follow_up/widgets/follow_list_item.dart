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

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("유저 데이터를 가져오는 중 오류 발생: $e");
    }
    return null;
  }

  Future<void> _loadUserData() async {
    final userData = await getUserData(widget.uid);
    if (mounted && userData != null && userData.containsKey("nickname")) {
      setState(() {
        name = userData["nickname"];

        profileImage = userData["profileImage"] ?? "assets/profile/default.png";
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

    final isFollowing = followProvider.following.any((user) => user["uid"] == widget.uid);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);


    if (!isFollowing) {
      return SizedBox.shrink();
    }

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profileImage!),
            ),
            title: Text(name!),
            trailing: ElevatedButton(
              onPressed: () {
                followProvider.unfollow(widget.uid);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(languageProvider.getLanguage(message: "언팔로우"), style: TextStyle(color: Colors.white)),
            ),
          );
  }
}
