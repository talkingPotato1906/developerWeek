import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_changer.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text(languageProvider.getLanguage(message: "오류")),
                  content: Text(languageProvider.getLanguage(message: "게시글을 불러오는 도중 오류가 발생했습니다.")),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(languageProvider.getLanguage(message: "확인")),
                    ),
                  ],
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return AlertDialog(
                  title: Text(languageProvider.getLanguage(message: "오류")),
                  content: Text(languageProvider.getLanguage(message: "게시글을 불러오는 도중 오류가 발생했습니다.")),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(languageProvider.getLanguage(message: "확인")),
                    ),
                  ],
                );
              }

              var postData = snapshot.data!.data() as Map<String, dynamic>;
              String title = postData["title"] ?? languageProvider.getLanguage(message: "제목 없음");
              String content = postData["content"] ?? languageProvider.getLanguage(message: "내용 없음");
              String category = postData["category"] ?? languageProvider.getLanguage(message: "일반");
              String imageUrl = postData["imageUrl"] ?? "";
              int reactions = postData["reactions"] ?? 0;
              bool isAddedToGallery = postData['is_added_to_gallery'] ?? false;
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

              return Dialog(
                backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
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
                                            color: ColorPalette.palette[themeProvider.selectedThemeIndex][4],
                                            child: Center(
                                                child: Text(languageProvider.getLanguage(message: "이미지 없음"))),
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
                                        color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        category,
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
                                    Divider(color: ColorPalette.palette[themeProvider.selectedThemeIndex][4]),
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
                            Divider(color: ColorPalette.palette[themeProvider.selectedThemeIndex][4]),
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
                                          ?ColorPalette.palette[themeProvider.selectedThemeIndex][2]
                                          : ColorPalette.palette[themeProvider.selectedThemeIndex][3],
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
                                        Text(
                                          languageProvider.getLanguage(message: "갤러리에 추가"),
                                          style: TextStyle(fontSize: 14),
                                          selectionColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
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
                                          backgroundColor:ColorPalette.palette[themeProvider.selectedThemeIndex][2],
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: Text(languageProvider.getLanguage(message: "삭제"),selectionColor: ColorPalette.palette[themeProvider.selectedThemeIndex][3])
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][4],
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: Text(languageProvider.getLanguage(message: "닫기"),selectionColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0]),
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
