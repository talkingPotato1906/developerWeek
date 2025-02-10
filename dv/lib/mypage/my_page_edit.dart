import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/firebase_login/get_user_data.dart';
import 'package:dv/mypage/choose_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//프로필 사진 업로드드

Future<void> updateProfileImage(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile =
      await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택

  if (pickedFile == null) return; // 이미지 선택 안 하면 종료

  try {
    // 🔹 Firebase Storage에 이미지 업로드
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String fileName =
        "profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putData(await pickedFile.readAsBytes()); // 🔹 웹 호환 업로드 방식

    // 🔹 업로드된 이미지의 URL 가져오기
    String imageUrl = await ref.getDownloadURL();

    // 🔹 Firestore에 프로필 이미지 URL 저장
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "profile": [imageUrl], // 기존에 없었다면 새로운 리스트로 대체
    });

    print("✅ 프로필 이미지 업데이트 성공: $imageUrl");

    // 🔹 다이얼로그 닫기
    Navigator.pop(context);

    // 🔹 마이페이지 새로고침 (Provider 상태 업데이트)
    Provider.of<GetUserData>(context, listen: false).getUserData();
  } catch (e) {
    print("🔥 프로필 이미지 업데이트 실패: $e");
  }
}

void showEditProfile(BuildContext context) {
  final getUserData = Provider.of<GetUserData>(context, listen: false);
  final List<dynamic> profiles = getUserData.userData["profile"];
  final String nickname = getUserData.userData["nickname"];

  TextEditingController nicknameController =
      TextEditingController(text: nickname);

  bool isEditing = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 프로필 이미지 영역
              GestureDetector(
                onTap: () {
                  // 🔹 구매한 프로필 선택 다이얼로그 호출
                  showProfileSelection(context); // choose_profile.dart의 함수 호출
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 🔹 프로필 사진
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profiles.isEmpty
                          ? AssetImage("assets/default.png")
                          : NetworkImage(profiles[0]) as ImageProvider,
                    ),
                    // 🔹 연필 아이콘 오버레이
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white.withOpacity(0.8),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 닉네임 수정 영역
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: isEditing
                          ? TextFormField(
                              controller: nicknameController,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty && value != nickname) {
                                  getUserData.updateNickname(value);
                                }
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    nickname,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                                  child: Icon(Icons.edit, size: 18),
                                )
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}
