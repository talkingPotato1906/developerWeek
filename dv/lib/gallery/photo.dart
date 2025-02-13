import 'package:dv/gallery/image_provider.dart';
import 'package:dv/login/login_provider.dart';
import 'package:dv/login/login_required_page.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'photo_features/gallery_check_overlay.dart'; // ✅ 체크 표시 UI 파일 추가
import 'photo_features/photo_display.dart';
import 'photo_features/photo_picker.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LogInProvider>(context);

    if (!loginProvider.isLoggedIn) {
      return const LoginRequiredPage();
    }

    return const PhotoPageContent();
  }
}

class PhotoPageContent extends StatefulWidget {
  const PhotoPageContent({super.key});

  @override
  _PhotoPageContentState createState() => _PhotoPageContentState();
}

class _PhotoPageContentState extends State<PhotoPageContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ImageProviderClass>(context, listen: false);
      if (mounted) {
        provider.fetchUserPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageProviderClass>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "나의 보관함")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: provider.images.length,
                itemBuilder: (context, index) {
                  final imageData = provider.images[index];
                  final String postId =
                      imageData["postId"] ?? ""; // ✅ Firestore 문서 ID 사용
                  bool isSelected = provider.selectedImages.contains(imageData);

                  return GestureDetector(
                    onTap: () async {
                      if (postId.isNotEmpty) {
                        bool? deleted = await showImageContent(
                            context, postId); // ✅ postId 기반으로 불러오기
                        if (deleted == true) {
                          setState(() {
                            provider.fetchUserPosts();
                          });
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0), // 둥근 네모 박스
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색 추가
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // ✅ Firestore에서 불러온 이미지 표시 (크기 조정)
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1.0), // 검은색 테두리 추가
                                  ),
                                  child: imageData["imageUrl"] != ""
                                      ? Image.network(
                                          imageData["imageUrl"],
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 300.0, // 주 이미지 크기 축소
                                        )
                                      : const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),

                            // ✅ 갤러리에 추가된 경우 체크 아이콘 표시
                            GalleryCheckOverlay(isSelected: isSelected),

                            // 추가된 bottom.png 이미지를 맨 아래에 표시
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/bottom.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 40.0, // bottom.png 크기 유지
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await pickImageAndComment(context);
          final provider =
              Provider.of<ImageProviderClass>(context, listen: false);
          await provider.fetchUserPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
