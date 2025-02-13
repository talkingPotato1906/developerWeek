import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_input_dialog.dart'; // 비밀번호 입력 다이얼로그 호출

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      return AlertDialog(
        title: Text(languageProvider.getLanguage(message: "회원탈퇴")),
        content: Text(languageProvider.getLanguage(message: "정말 회원탈퇴를 진행하시겠습니까? 게시물은 자동으로 삭제되지 않습니다.")),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: Text(languageProvider.getLanguage(message: "취소")),
          ),
          // 진행 버튼
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 🔹 현재 다이얼로그 닫기
              Future.delayed(Duration.zero, () {
                // 🔹 Navigator.pop 이후에 showPasswordDialog 호출
                showPasswordDialog(context);
              });
            },
            child: Text(languageProvider.getLanguage(message: "진행")),
          ),
        ],
      );
    },
  );
}
