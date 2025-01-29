import 'package:flutter/material.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전시장"), // 페이지 1 제목
      ),
      body: Center(
        child: Text(
          "전시대가 비었습니다.",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
