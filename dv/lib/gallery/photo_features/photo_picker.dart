import 'dart:typed_data';

import 'package:dv/gallery/image_provider.dart'; // ✅ ImageProviderClass 가져오기
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // ✅ Provider 추가

Future<void> pickImageAndComment(
  BuildContext context, {
  Uint8List? existingImage, // ✅ 기존 이미지를 유지하는 변수 추가
  String? existingTitle,
  String? existingContent,
}) async {
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;

  // ✅ 새 이미지 업로드 시, 기존 이미지가 없을 경우에만 선택 가능
  if (existingImage == null) {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
  }

  final bytes = existingImage ?? await pickedFile!.readAsBytes();
  TextEditingController titleController =
      TextEditingController(text: existingTitle ?? "");
  TextEditingController contentController =
      TextEditingController(text: existingContent ?? "");

  final Map<String, String>? result = await showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
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
                if (existingImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.7,
                    ),
                  ),
                SizedBox(height: 10),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), // 아래쪽 여백 추가
                    child: TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        labelText: "내용",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.top, // ✅ 텍스트를 위쪽 정렬
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                ),
                SizedBox(height: 10), // 내용 입력칸과 확인 버튼 사이의 거리 조정
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        "title": titleController.text,
                        "content": contentController.text,
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

// ✅ 반환된 값이 있는 경우 `addImage` 실행 (제목 & 내용이 없어도 가능)
  if (result != null) {
    final provider = Provider.of<ImageProviderClass>(context, listen: false);

    provider.addImage({
      "image": bytes,
      "title": result["title"]!.isNotEmpty
          ? result["title"]!
          : "제목 없음", // ✅ 제목이 없으면 기본값 설정
      "content": result["content"]!.isNotEmpty
          ? result["content"]!
          : "내용 없음", // ✅ 내용이 없으면 기본값 설정
    });

    // ✅ UI 업데이트
    provider.notifyListeners();
  }
}
