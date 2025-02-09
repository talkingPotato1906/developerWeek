import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool?> showImageContent(BuildContext context, String postId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return FutureBuilder<DocumentSnapshot>(
        future: firestore.collection("posts").doc(postId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text("오류"),
              content: const Text("데이터를 불러오는 중 오류가 발생했습니다."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // 🔹 false 반환
                  child: const Text("확인"),
                ),
              ],
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return AlertDialog(
              title: const Text("오류"),
              content: const Text("게시글 데이터를 찾을 수 없습니다."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // 🔹 false 반환
                  child: const Text("확인"),
                ),
              ],
            );
          }

          var postData = snapshot.data!.data() as Map<String, dynamic>;
          String title = postData["title"] ?? "제목 없음";
          String content = postData["content"] ?? "내용 없음";
          String category = postData["category"] ?? "일반";
          String imageUrl = postData["imageUrl"] ?? "";
          int reactions = postData["reactions"] ?? 0;

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    color: Colors.grey[300],
                                    child: const Center(child: Text("이미지 없음")),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "카테고리: $category",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      content,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(reactions.toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await firestore
                                    .collection("posts")
                                    .doc(postId)
                                    .delete();
                                Navigator.of(context).pop(true); // ✅ 삭제 성공 시 true 반환
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text("삭제",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // ✅ 닫기 시 false 반환
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text("닫기",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ) ?? false; // 🔹 기본값 false 반환
}

