import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:flutter/material.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("갤러리 전시"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // Firestore 쿼리: is_added_to_gallery가 true인 데이터만 가져오기
        future: FirebaseFirestore.instance
            .collection("posts")
            .where("is_added_to_gallery", isEqualTo: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("데이터를 가져오는 중 오류가 발생했습니다."));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("전시할 게시물이 없습니다."));
          }

          final posts = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final imageUrl = post["imageUrl"] ?? "";
              final title = post["title"] ?? "제목 없음";
              final postId = posts[index].id; // 🔥 Firestore 문서 ID 가져오기

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPostScreen(
                        postId: postId, // 문서 ID 전달
                        title: title, // 제목 전달
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0)),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text("이미지 없음"),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
