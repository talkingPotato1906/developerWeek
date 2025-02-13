//헤더 및 로그인 체크
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget showroomAppBar(BuildContext context) {
  final languageProvider = Provider.of<LanguageProvider>(context);
  return AppBar(
    title: Text(languageProvider.getLanguage(message: languageProvider.getLanguage(message: "갤러리"))),
    automaticallyImplyLeading: false,
  );
}

Widget? showroomLoginCheck(BuildContext context, bool isLoggedIn) {
  final languageProvider = Provider.of<LanguageProvider>(context);
  if (!isLoggedIn) {
    return Center(
      child: Text(
        languageProvider.getLanguage(message: "로그인이 필요한 서비스입니다."),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
  return null;
}
