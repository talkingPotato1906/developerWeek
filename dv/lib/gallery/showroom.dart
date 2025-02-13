import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:dv/settings/language/language_changer.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "갤러리")),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // Firestore 쿼리: is_added_to_gallery가 true인 데이터만 가져오기
        future: FirebaseFirestore.instance
            .collection("posts")
            .where("is_added_to_gallery", isEqualTo: true)
            .where("uid", isEqualTo: currentUserUid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(languageProvider.getLanguage(message: "게시글을 불러오는 도중 오류가 발생했습니다.")));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(languageProvider.getLanguage(message: "전시할 게시물이 없습니다.")));
          }

          final posts = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 300).floor();
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount < 1 ? 1 : crossAxisCount,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index].data() as Map<String, dynamic>;
                  final imageUrl = post["imageUrl"] ?? "";
                  final title = post["title"] ?? languageProvider.getLanguage(message: "제목 없음");
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
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 박스 배경색 추가
                                  Container(
                                    color: Colors.blueGrey[50], // 원하는 색상으로 변경
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.85,
                                      heightFactor: 0.85,
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Text(languageProvider.getLanguage(message: "이미지 없음")),
                                              ),
                                            ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.85,
                                      heightFactor: 0.85,
                                      child: Image.asset(
                                        'showcase.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
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
          );
        },
      ),
    );
  }
}
