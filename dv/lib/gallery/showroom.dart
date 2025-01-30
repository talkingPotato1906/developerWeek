import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {

    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "갤러리")), // 페이지 1 제목
      ),
      body: Center(
        child: Text(
          languageProvider.getLanguage(message: "갤러리가 비어있습니다"),
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
