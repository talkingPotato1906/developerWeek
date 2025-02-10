import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:dv/follow_up/providers/follow_provider.dart';
import 'package:dv/menu/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OthersGalleryScreen extends StatefulWidget {
  final String othersUid;

  const OthersGalleryScreen({super.key, required this.othersUid});

  @override
  _OthersGalleryScreenState createState() => _OthersGalleryScreenState();
}

class _OthersGalleryScreenState extends State<OthersGalleryScreen> {
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> user = {};
  List<dynamic> following = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchUser();
    await fetchPosts();
    await fetchCurrentUserFollowing();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.othersUid)
        .orderBy("createdAt", descending: true)
        .get();
    setState(() {
      posts = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "title": doc["title"] ?? "",
          "uid": doc["uid"],
          "createdAt": doc["createdAt"],
          "imageUrl": doc["imageUrl"],
          "content": doc["content"],
          "category": doc["category"],
          "reactions": doc["reactions"]
        };
      }).toList();
    });
  }

  Future<void> fetchUser() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.othersUid)
        .get();

    setState(() {
      user = documentSnapshot.data() as Map<String, dynamic>;
    });
  }

  Future<void> fetchCurrentUserFollowing() async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> currentUserData =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(
        () {
          following = List<dynamic>.from(currentUserData["following"] ?? []);
        },
      );
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
        title: Text(user["nickname"] ?? "..."),
      ),
      floatingActionButton: FloatingMenuButton(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : user.isEmpty || posts.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    //  프로필
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: user["profile"].isNotEmpty
                                    ? NetworkImage(
                                        user["profile"][user["profileIdx"]])
                                    : null,
                                child: user["profile"].isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 30,
                                      )
                                    : null,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                user["nickname"],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          widget.othersUid !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? SizedBox()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (!following.contains(posts[0]["uid"])) {
                                      await followProvider
                                          .follow(posts[0]["uid"]);
                                    } else {
                                      await followProvider
                                          .unfollow(posts[0]["uid"]);
                                    }

                                    // 🔹 최신 팔로우 목록을 가져오고 UI 업데이트
                                    await fetchCurrentUserFollowing();
                                    setState(() {}); // UI 강제 업데이트
                                  },
                                  child: Text(
                                      following.contains(posts[0]["uid"])
                                          ? "언팔로우"
                                          : "팔로우"),
                                )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("제목",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      Text("날짜",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Expanded(
                              child: posts.isEmpty
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: posts.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var post = posts[index];
                                        return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CategoryPostScreen(
                                                                postId:
                                                                    post["id"],
                                                                title: post[
                                                                    "title"]),
                                                      ));
                                                },
                                                child: Text(post["title"],
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              Text(formatTimestamp(
                                                  post["createdAt"]))
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(onPressed: () {}, child: Text("1")),
                                TextButton(onPressed: () {}, child: Text("2")),
                                TextButton(onPressed: () {}, child: Text("3")),
                                TextButton(onPressed: () {}, child: Text("4")),
                                TextButton(onPressed: () {}, child: Text("5")),
                                TextButton(onPressed: () {}, child: Text("다음")),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
