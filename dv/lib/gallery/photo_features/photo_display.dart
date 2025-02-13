import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool?> showImageContent(BuildContext context, String postId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Future<DocumentSnapshot> fetchPost() {
            return firestore.collection("posts").doc(postId).get();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: fetchPost(),
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
                      onPressed: () => Navigator.of(context).pop(false),
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
                      onPressed: () => Navigator.of(context).pop(false),
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
              bool isAddedToGallery = postData['is_added_to_gallery'] ?? false;

              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 이미지와 카테고리 영역
                              Stack(
                                children: [
                                  // 이미지
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            color: Colors.grey[300],
                                            child: const Center(
                                                child: Text("이미지 없음")),
                                          ),
                                  ),
                                  // 카테고리
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
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
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // 제목과 내용
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 제목
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    // 구분선
                                    Divider(color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    // 내용
                                    Text(
                                      content,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 하단 고정 영역
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 구분선
                            Divider(color: Colors.grey[400]),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 갤러리에 추가 버튼
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await firestore
                                            .collection("posts")
                                            .doc(postId)
                                            .update({
                                          'is_added_to_gallery':
                                              !isAddedToGallery
                                        });
                                        setState(() {
                                          isAddedToGallery = !isAddedToGallery;
                                        });
                                      } catch (e) {
                                        print("갤러리 상태 업데이트 오류: $e");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      backgroundColor: isAddedToGallery
                                          ? Colors.green
                                          : Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isAddedToGallery,
                                          onChanged: (bool? newValue) async {
                                            if (newValue != null) {
                                              try {
                                                await firestore
                                                    .collection("posts")
                                                    .doc(postId)
                                                    .update({
                                                  'is_added_to_gallery':
                                                      newValue
                                                });
                                                setState(() {
                                                  isAddedToGallery = newValue;
                                                });
                                              } catch (e) {
                                                print("갤러리 상태 업데이트 오류: $e");
                                              }
                                            }
                                          },
                                        ),
                                        const Text(
                                          "갤러리에 추가",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 삭제 및 닫기 버튼
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await firestore
                                              .collection("posts")
                                              .doc(postId)
                                              .delete();
                                          Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: const Text("삭제"),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: const Text("닫기"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  );
}
