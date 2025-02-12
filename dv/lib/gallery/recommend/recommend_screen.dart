import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/firebase_login/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic>? userData; // userData를 nullable로 변경
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchUser();
    await fetchPosts();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUser() async {
    final getUserData = Provider.of<GetUserData>(context, listen: false);

    if (mounted) {
      setState(() {
        userData = Map<String, dynamic>.from(getUserData.userData);
      });
    }
  }

  Future<void> fetchPosts() async {
    if (userData == null || !userData!.containsKey("following")) {
      return; // userData가 없으면 그냥 리턴
    }

    List<dynamic> followingList =
        List<dynamic>.from(userData!["following"] ?? []);

    if (followingList.isEmpty) {
      return; // 팔로우한 사람이 없으면 그냥 리턴
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where("uid", whereIn: followingList)
        .orderBy("createdAt", descending: true)
        .get();

    if (mounted) {
      setState(() {
        posts = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "title": doc["title"],
            "uid": doc["uid"],
            "createdAt": doc["createdAt"],
            "imageUrl": doc["imageUrl"],
            "content": doc["content"],
            "reactions": doc["reactions"]
          };
        }).toList();
      });
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text("팔로우한 게시글"),
            ),
            body: userData == null || posts.isEmpty
                ? Center(child: Text("게시글이 없습니다."))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      return ListTile(
                        title: Text(post["title"]),
                        subtitle: Text(formatTimestamp(post["createdAt"])),
                        onTap: () {
                          // 게시글 상세 페이지로 이동하는 코드 추가 예정
                        },
                      );
                    },
                  ),
          );
  }
}
