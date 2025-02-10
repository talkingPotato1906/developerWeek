import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/follow_up/providers/follow_provider.dart';
import 'package:dv/menu/menu.dart';
import 'package:dv/others_gallery/others_gallery_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategoryPostScreen extends StatefulWidget {
  final String postId;
  final String title;

  const CategoryPostScreen(
      {super.key, required this.postId, required this.title});

  @override
  _CategoryPostScreenState createState() => _CategoryPostScreenState();
}

class _CategoryPostScreenState extends State<CategoryPostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? postData;
  Map<String, dynamic>? userData;
  List<dynamic> following = [];
  bool isLoading = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchPostData();
    checkIfLiked();
  }

  //  데이터 불러오기
  Future<void> fetchPostData() async {
    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.postId)
          .get();

      if (postSnapshot.exists) {
        setState(() {
          postData = postSnapshot.data() as Map<String, dynamic>;
        });

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(postData!["uid"])
            .get();

        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  //  이미 하트 눌렀는지 확인
  void checkIfLiked() async {
    String uid = _auth.currentUser!.uid;

    DocumentSnapshot postSnapshot =
        await _firestore.collection("posts").doc(widget.postId).get();

    List<dynamic> reactedUsers = postSnapshot["reacted"] ?? [];

    if (reactedUsers.contains(uid)) {
      setState(() {
        _isLiked = true;
      });
    }
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

  //  하트 클릭 시 반응
  Future<void> _handleLike() async {
    String uid = _auth.currentUser!.uid;

    // 현재 게시글의 작성자 UID 확인
    String authorId = postData?["uid"] ?? "";

    if (uid == authorId || _isLiked) {
      print("User cannot like their own post or like again.");
      return;
    }

    try {
      await _firestore.runTransaction((transaction) async {
        // 게시글 문서 참조
        DocumentReference postRef =
            _firestore.collection("posts").doc(widget.postId);

        // 작성자 문서 참조
        DocumentReference userRef =
            _firestore.collection("users").doc(authorId);

        // 모든 읽기 작업 수행
        DocumentSnapshot postSnapshot = await transaction.get(postRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (!postSnapshot.exists) {
          print("❌ Post document does not exist.");
          return;
        }

        if (!userSnapshot.exists) {
          print("❌ User document does not exist for ID: $authorId");
          return;
        }

        // 읽은 데이터 처리
        int currentReactions =
            (postSnapshot.data() as Map<String, dynamic>)["reactions"] ?? 0;
        List<dynamic> reactedUsers =
            (postSnapshot.data() as Map<String, dynamic>)["reacted"] ?? [];
        int currentPoints =
            (userSnapshot.data() as Map<String, dynamic>)["points"] ?? 0;

        if (!reactedUsers.contains(uid)) {
          reactedUsers.add(uid);

          // 모든 쓰기 작업 수행
          transaction.update(postRef, {
            "reactions": currentReactions + 1,
            "reacted": reactedUsers,
          });

          transaction.update(userRef, {"points": currentPoints + 50});

          print("✅ Post reactions updated: $currentReactions + 1");
          print("✅ User points updated: $currentPoints + 50");
        } else {
          _isLiked = true;
          print("User already reacted to this post.");
        }
      });

      // UI 업데이트
      setState(() {
        _isLiked = true;
        postData?["reactions"] = (postData?["reactions"] ?? 0) + 1;
      });

      print("✅ Like successfully updated.");
    } catch (e, stackTrace) {
      print("🔥 Error updating like: $e");
      print("📌 Stack trace: $stackTrace");
    }
  }

  //  날짜 포맷 함수
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingMenuButton(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : postData == null || userData == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  작성자 프로필, 닉네임
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userData!["profile"]
                                          .isNotEmpty
                                      ? NetworkImage(
                                          userData!["profile"] is List<dynamic>
                                              ? userData!["profile"][0]
                                              : userData!["profile"])
                                      : null,
                                  child: userData!["profile"].isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 30,
                                        )
                                      : null),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OthersGalleryScreen(
                                                othersUid: postData!["uid"]),
                                      ));
                                },
                                child: Text(
                                  userData!["nickname"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          _auth.currentUser!.uid == postData!["uid"]
                              ? SizedBox()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (!following.contains(postData!["uid"])) {
                                      await followProvider
                                          .follow(postData!["uid"]);
                                    } else {
                                      await followProvider
                                          .unfollow(postData!["uid"]);
                                    }

                                    // 🔹 최신 팔로우 목록을 가져오고 UI 업데이트
                                    await fetchCurrentUserFollowing();
                                    setState(() {}); // UI 강제 업데이트
                                  },
                                  child: Text(
                                      following.contains(postData!["uid"])
                                          ? "언팔로우"
                                          : "팔로우"),
                                )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //  게시글
                      Text(
                        postData!["title"],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(formatTimestamp(postData!["createdAt"]),
                          style: TextStyle(fontSize: 12)),
                      SizedBox(
                        height: 10,
                      ),
                      postData!["imageUrl"] != null
                          ? Image.network(postData!["imageUrl"],
                              fit: BoxFit.contain, width: double.infinity)
                          : Container(),

                      SizedBox(height: 20),
                      Text(postData!["content"],
                          style: TextStyle(fontSize: 16)),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _handleLike,
                            child: Icon(
                              Icons.favorite,
                              color: _isLiked
                                  ? Colors.red
                                  : Colors.grey, // 누르면 빨간색
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(postData!['reactions'].toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
    );
  }
}
