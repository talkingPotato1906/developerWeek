import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/gallery/photo_features/photo_display.dart';
import 'package:flutter/material.dart';

void showEditImageDialog(BuildContext context, String postId) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  showDialog(
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
              content: const Text("게시글을 불러오는 중 오류가 발생했습니다."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("확인"),
                ),
              ],
            );
          }

          // ✅ Firestore에서 데이터 가져오기
          var postData = snapshot.data!.data() as Map<String, dynamic>;
          TextEditingController titleController =
              TextEditingController(text: postData["title"] ?? "제목 없음");
          TextEditingController contentController =
              TextEditingController(text: postData["content"] ?? "내용 없음");

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // ✅ 둥근 테두리 적용
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 제목 입력 필드
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "제목",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // 내용 입력 필드 (확장 가능)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            labelText: "내용",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          expands: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // 여백 추가

                    // 버튼 정렬
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _updatePost(postId, titleController.text, contentController.text);

                          // ✅ 다이얼로그 닫기
                          Navigator.of(context, rootNavigator: true).pop();

                          // ✅ Firestore에서 업데이트된 데이터 다시 불러오기
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showImageContent(context, postId);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("수정 완료", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// ✅ Firestore에서 게시글 데이터 업데이트
Future<void> _updatePost(String postId, String newTitle, String newContent) async {
  try {
    await FirebaseFirestore.instance.collection("posts").doc(postId).update({
      "title": newTitle,
      "content": newContent,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("게시글 수정 오류: $e");
  }
}
