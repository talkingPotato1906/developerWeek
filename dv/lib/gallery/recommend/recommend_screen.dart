import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:dv/firebase_login/get_user_data.dart';
import 'package:dv/settings/language/language_changer.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
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
  bool isLoading = true;
  bool hasFetchedPosts = false; // ✅ 중복 실행 방지

  @override
  void initState() {
    super.initState();
    print("🔥 RecommendScreen initState() 실행됨");
  }

  Future<void> fetchPosts(List<dynamic> followingList) async {
    print("🔄 fetchPosts() 실행됨 - followingList: $followingList");
    if (followingList.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where("uid", whereIn: followingList)
          .orderBy("createdAt", descending: true)
          .limit(50)
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
          isLoading = false;
          hasFetchedPosts = true; // ✅ 중복 실행 방지
        });
      }
      print("✅ fetchPosts() 완료 - 불러온 게시글 개수: ${posts.length}");
    } catch (e) {
      print("🔥 Error fetching posts: $e");
      setState(() => isLoading = false);
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown date";
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    print("🔥 RecommendScreen build() 실행됨");

    return Consumer<GetUserData>(builder: (context, getUserData, child) {
      if (getUserData.isLoading) {
        print("⏳ getUserData가 아직 로드 중...");
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // userData 가져오기
      Map<String, dynamic>? userData = getUserData.userData;
      print("🔹 userData 불러옴: $userData");

      if (userData == null || !userData.containsKey("following")) {
        print("❌ userData가 없거나 following이 없음");
        return Scaffold(body: Center(child: Text("게시글이 없습니다.")));
      }

      // 팔로우한 유저 목록 가져오기
      List<dynamic> followingList = List<dynamic>.from(userData["following"] ?? []);

      // UI 빌드 이후 fetchPosts 실행 (최초 한 번만 실행)
      if (!hasFetchedPosts) {
        hasFetchedPosts = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          fetchPosts(followingList);
        });
      }

      return Scaffold(
        appBar: AppBar(title: Text("팔로우한 게시글")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : posts.isEmpty
                ? Center(child: Text("게시글이 없습니다."))
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return ListTile(
                          title: Text(post["title"] ?? "No Title", style: TextStyle(color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],)),
                          subtitle: Text(formatTimestamp(post["createdAt"]), style: TextStyle(color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPostScreen(
                                  postId: post["id"], // 문서 ID
                                  title: post["title"], // 게시글 제목
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ),
      );
    });
  }
}
