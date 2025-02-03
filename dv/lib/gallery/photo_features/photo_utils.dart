//갤러리 최대 선택 제한 경고
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showMaxSelectionWarning(BuildContext context) {
  final languageProvider =
      Provider.of<LanguageProvider>(context, listen: false);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: themeProvider.getTheme().colorScheme.surface,
        title: Text(languageProvider.getLanguage(message: "갤러리 선택 제한")),
        content: Text(
            languageProvider.getLanguage(message: "최대 9개의 전시품만 선택할 수 있습니다.")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}
