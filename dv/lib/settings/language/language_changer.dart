import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageChanger extends StatelessWidget{
  const LanguageChanger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final List<String> languageNames = [
      "English", "한국어", "日本語", "中文"
    ];
    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            languageProvider.getLanguage(message: "언어 선택"),  // 언어 선택
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: 30,
          ),
          // 테마 변경 드롭다운 버튼
          DropdownButton<int>(
            dropdownColor: ColorPalette.palette[themeProvider.selectedThemeIndex][1],
            borderRadius: BorderRadius.circular(10),
            value: languageProvider.selectedLanguageIndex,
            items: List.generate(
              languageNames.length,
              (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Text(languageNames[index]),
                    ],
                  ),
                );
              },
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<LanguageProvider>().changeLanguage(value);
              }
            },
          )
        ],
      ),
    );
  }
}