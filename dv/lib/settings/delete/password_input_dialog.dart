import 'package:dv/firebase_login/signup_login_screen.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'delete_user_logic.dart'; // 회원탈퇴 로직 호출

void showPasswordDialog(BuildContext context) {
  final TextEditingController passwordController = TextEditingController();
  final LanguageProvider languageProvider =
      Provider.of<LanguageProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("비밀번호 확인"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("비밀번호를 입력해 회원탈퇴를 진행하세요."),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true, // 비밀번호 숨김
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "비밀번호",
              ),
            ),
          ],
        ),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: Text("취소"),
          ),
          // 확인 버튼
          ElevatedButton(
            onPressed: () async {
              String password = passwordController.text;
              if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("비밀번호를 입력해주세요.")),
                );
                return;
              }

              // 🔹 회원탈퇴 로직 호출
              await deleteUser(context, password);

              // 회원탈퇴 완료 메시지
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(languageProvider.getLanguage(message: "회원탈퇴 되었습니다")),
                  duration: Duration(seconds: 2),
                ),
              );

              // 로그인 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}
