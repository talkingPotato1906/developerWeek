import 'package:dv/gallery/image_provider.dart';
import 'package:dv/gallery/photo_features/design_/title_flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../photo_features/edit_image_dialog.dart';

void showImageContent(BuildContext context, int index) {
  final provider = Provider.of<ImageProviderClass>(context, listen: false);
  final imageData = provider.images[index];

  showDialog(
    context: context,
    builder: (context) {
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
                      // ✅ 왼쪽: 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.memory(
                            imageData["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // ✅ 오른쪽: 제목 & 내용
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ 새로운 TitleFlag 위젯 사용
                            TitleFlag(title: imageData["title"]),
                            const SizedBox(height: 8),

                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  imageData["content"],
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

                // ✅ 버튼 정렬 (체크박스 버튼 왼쪽, 삭제/수정 버튼 오른쪽)
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ✅ 갤러리 추가 버튼
                        Consumer<ImageProviderClass>(
                          builder: (context, provider, child) {
                            bool isSelected =
                                provider.selectedImages.contains(imageData);

                            return ElevatedButton.icon(
                              onPressed: () {
                                if (!isSelected &&
                                    provider.selectedImages.length >= 9) {
                                  _showMaxSelectionWarning(context);
                                } else {
                                  provider.toggleGalleryImage(imageData);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              icon: isSelected
                                  ? const Icon(Icons.check_box,
                                      color: Colors.white)
                                  : const Icon(Icons.check_box_outline_blank,
                                      color: Colors.white),
                              label: const Text("갤러리에 추가",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          },
                        ),

                        // ✅ 삭제 및 수정 버튼
                        Row(
                          children: [
                            // 수정 버튼
                            ElevatedButton(
                              onPressed: () {
                                showEditImageDialog(context, index);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text("수정",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                            const SizedBox(width: 8),

                            // 삭제 버튼
                            ElevatedButton(
                              onPressed: () {
                                provider.removeImage(index);
                                Navigator.of(context).pop();
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
                          ],
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
}

// ✅ 최대 선택 제한 경고 다이얼로그 (올바르게 추가)
void _showMaxSelectionWarning(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("갤러리 선택 제한"),
        content: const Text("최대 9개의 전시품만 선택할 수 있습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("확인"),
          ),
        ],
      );
    },
  );
}
