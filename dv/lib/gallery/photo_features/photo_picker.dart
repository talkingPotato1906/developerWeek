import 'dart:io';
import 'dart:typed_data';

import 'package:dv/firebase_upload/post_service.dart';
import 'package:dv/gallery/image_provider.dart'; // ✅ ImageProviderClass 가져오기
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Provider 추가
import 'package:flutter/foundation.dart'; // ✅ 웹과 모바일 환경 구분용

Future<void> pickImageAndComment(
  BuildContext context, {
  Uint8List? existingImage, // ✅ 기존 이미지를 유지하는 변수 추가
  String? existingTitle,
  String? existingContent,
  String? existingCategory,
  String? existingImageUrl, // ✅ Firestore에 저장된 기존 이미지 URL
}) async {
  print("pickImageAndComment 실행!");

  final PostService postService = PostService();
  final imageProvider = Provider.of<ImageProviderClass>(context, listen: false);

  dynamic imageFile;

  // ✅ 기존 이미지가 없을 때만 새로운 이미지 선택 가능
  if (existingImage == null) {
    print("이미지 선택");
    imageFile = await postService.pickImage();
    if (imageFile == null) {
      print("이미지 선택 취소");
      return;
    }
    print("이미지 선택 완료");
  }

  // ✅ 선택한 새 이미지가 없으면 기존 이미지 유지
  final Uint8List imageBytes = existingImage ??
      (imageFile is Uint8List
          ? imageFile
          : await (imageFile as File).readAsBytes());

  TextEditingController titleController =
      TextEditingController(text: existingTitle ?? "");
  TextEditingController contentController =
      TextEditingController(text: existingContent ?? "");

  // ✅ 기본 카테고리 설정
  String selectedCategory = existingCategory ?? "식물"; 

  final Map<String, String>? result = await showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      print("다이얼로그 열림!");
      return StatefulBuilder( // ✅ 다이얼로그 내부에서 상태 변경을 가능하게 함
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.7, // ✅ 높이 증가
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),

                    // ✅ 카테고리 선택 Dropdown 추가
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: "카테고리 선택",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      items: ["식물", "식기", "주류", "원석", "책", "피규어"].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() { // ✅ 변경 시 UI 업데이트
                            selectedCategory = newValue;
                          });
                        }
                      },
                    ),

                    SizedBox(height: 10), 
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          print("다이얼로그 확인 버튼 클릭!");
                          Navigator.of(context).pop({
                            "title": titleController.text,
                            "content": contentController.text,
                            "category": selectedCategory, // ✅ 카테고리 값 추가
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
    },
  );

  // ✅ Firestore에 게시글 저장
  if (result != null) {
    print("result 넘어옴!");
    String? imageUrl = existingImageUrl;

    // ✅ 새로운 이미지를 선택한 경우 Firestore에 업로드
    if (existingImage == null && imageFile != null) {
      print("이미지 업로드 시작!");
      imageUrl = await postService.uploadImage(imageFile);
      print("이미지 업로드 완료!");
    }
    print("업로드할 데이터: ${result["title"]}");

    await postService.uploadPost(
      title: result["title"]!,
      content: result["content"]!,
      imageFile: imageUrl ?? "", 
      category: result["category"]!, // ✅ 카테고리 포함하여 업로드
    );
    print("uploadPost 함수 호출!");

    imageProvider.addImage({
      "image": imageBytes,
      "title": result["title"]!.isNotEmpty
          ? result["title"]!
          : "제목 없음",
      "content": result["content"]!.isNotEmpty
          ? result["content"]!
          : "내용 없음",
      "category": result["category"]!, // ✅ 카테고리 추가
    });
  }
}
