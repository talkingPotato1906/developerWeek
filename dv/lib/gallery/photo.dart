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

    return PhotoPageContent();
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: provider.images.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      provider.selectedImages.contains(provider.images[index]);

                  return GestureDetector(
                    onTap: () => showImageContent(context, index),
                    child: Stack(
                      children: [
                        // ✅ 이미지 표시
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: provider.images[index]["imageUrl"] != ""
                              ? Image.network(
                                  provider.images[index]["imageUrl"],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),

                        // ✅ 갤러리에 추가된 경우 체크 아이콘 표시
                        GalleryCheckOverlay(isSelected: isSelected),
                      ],
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
