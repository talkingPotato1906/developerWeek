//Firebase와 연동하여 비밀번호 확인 및 사용자 데이터를 삭제
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/firebase_login/signup_login_screen.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> deleteUser(BuildContext context, String password) async {
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  try {
    // 현재 로그인한 사용자 가져오기
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception(languageProvider.getLanguage(message: "사용자가 로그인되어 있지 않습니다."));
    }

    // 비밀번호로 사용자 인증
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

   

    // 🔹 Firestore 데이터 삭제
    await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();

    // 🔹 Firebase Storage 데이터 삭제 (예: 프로필 사진)
    final storageRef = FirebaseStorage.instance.ref().child("profile_images/${user.uid}/");
    ListResult files = await storageRef.listAll();
    for (var file in files.items) {
      await file.delete();
    }

    // 🔹 사용자 계정 삭제
    await user.delete();

     // Authentication 강제 삭제
    await FirebaseAuth.instance.signOut();

  

    // 성공 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(languageProvider.getLanguage(message: "회원탈퇴가 완료되었습니다."))),
    );

    // 회원탈퇴 후 화면 이동 (예: 로그인 화면)
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => LoginScreen(),)
    );
  } catch (e) {
    print("🔥 회원탈퇴 실패: $e");
  }
}
