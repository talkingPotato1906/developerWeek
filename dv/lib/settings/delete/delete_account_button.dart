//회원탈퇴 버튼의 UI 코드와 클릭 이벤트
import 'package:flutter/material.dart';

import 'delete_confirmation_dialog.dart'; // 회원탈퇴 확인 다이얼로그 호출

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // 버튼 색상 (빨간색)
        ),
        onPressed: () {
          showDeleteAccountDialog(context); // 🔹 회원탈퇴 다이얼로그 호출
        },
        child: Text(
          "회원탈퇴",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
