import 'package:flutter/material.dart';

import 'password_input_dialog.dart'; // 비밀번호 입력 다이얼로그 호출

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("회원탈퇴"),
        content: Text("정말로 회원탈퇴를 진행하시겠습니까?"),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: Text("취소"),
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
            child: Text("진행"),
          ),
        ],
      );
    },
  );
}
