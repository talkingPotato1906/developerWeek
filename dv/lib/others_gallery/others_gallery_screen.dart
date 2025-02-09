import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:dv/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OthersGalleryScreen extends StatefulWidget {
  final String othersUid;

  const OthersGalleryScreen({super.key, required this.othersUid});

  @override
  _OthersGalleryScreenState createState() => _OthersGalleryScreenState();
}

class _OthersGalleryScreenState extends State<OthersGalleryScreen> {
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> user = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchUser();
    await fetchPosts();
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

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: user["profile"].isNotEmpty
                                ? NetworkImage(user["profile"][user["profileIdx"]]
                                    )
                                : null,
                            child: user["profile"].isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                  )
                                : null,
                          ),
                          Text(
                            user["nickname"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
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
                            Expanded(child: posts.isEmpty
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
                                  ),),
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
