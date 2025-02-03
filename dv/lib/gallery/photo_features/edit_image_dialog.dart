import 'package:dv/gallery/photo_features/photo_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../image_provider.dart';

void showEditImageDialog(BuildContext context, int index) {
  final provider = Provider.of<ImageProviderClass>(context, listen: false);
  final imageData = provider.images[index];

  TextEditingController titleController =
      TextEditingController(text: imageData["title"]);
  TextEditingController contentController =
      TextEditingController(text: imageData["content"]);

  showDialog(
    context: context,
    builder: (context) {
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
                      borderRadius: BorderRadius.circular(12.0), // ✅ 둥근 테두리 적용
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
                          borderRadius:
                              BorderRadius.circular(12.0), // ✅ 둥근 테두리 적용
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
                    onPressed: () {
                      provider.updateImage(
                          index, titleController.text, contentController.text);

                      // ✅ 현재 열린 모든 다이얼로그를 닫기
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // 수정 다이얼로그 닫기
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // 기존 이미지 보기 다이얼로그 닫기

                      // ✅ 화면이 다시 그려질 수 있도록 상태 업데이트 후 다이얼로그 다시 열기
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showImageContent(context, index);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child:
                        const Text("확인", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
