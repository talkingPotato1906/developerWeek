// 설정에서 사용할 언어 변환 드롭다운 박스
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageChanger extends StatelessWidget {
  const LanguageChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context); // 테마 적용
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context); // 언어 적용
    final List<String> languageNames = [
      "English",
      "한국어",
      "日本語",
      "中文"
    ]; // 드롭다운 박스 선택지 문자열

    return Padding(
      padding: const EdgeInsets.all(20), //  패딩 값 20
      child: Row(
        children: [
          Text(
            languageProvider.getLanguage(message: "언어 선택"), // 언어 선택
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: 30,
          ),
          // 언어 변경 드롭다운 버튼
          DropdownButton<int>(
            dropdownColor:
                ColorPalette.palette[themeProvider.selectedThemeIndex][1],
            borderRadius: BorderRadius.circular(10),
            value: languageProvider.selectedLanguageIndex, // 현재 선택된 언어가 보이도록
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
            //  드롭다운 박스에서 언어 선택 시 해당 언어로 변경
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
