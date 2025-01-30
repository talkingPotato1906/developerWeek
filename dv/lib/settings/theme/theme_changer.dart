import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final List<List<String>> themeNames = [
      ["Plant", "Cutlery", "Liquor", "Gemstone"],
      ["식물", "식기", "주류", "원석"],
      ["植物", "食器", "酒", "宝石"],
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            languageProvider.getLanguage(message: "테마 선택"), // 테마 선택
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          // 테마 변경 드롭다운 버튼
          DropdownButton<int>(
            dropdownColor:
                ColorPalette.palette[themeProvider.selectedThemeIndex][1],
            borderRadius: BorderRadius.circular(10),
            value: themeProvider.selectedThemeIndex,
            items: List.generate(
              4,
              (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(themeNames[languageProvider.selectedLanguageIndex]
                          [index]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorPalette.palette[index][2],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: ColorPalette.palette[index][3],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<ThemeProvider>().changeTheme(value);
              }
            },
            selectedItemBuilder: (context) {
              return List.generate(
                4,
                (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(themeNames[languageProvider.selectedLanguageIndex]
                          [themeProvider.selectedThemeIndex]),
                      SizedBox(width: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorPalette.palette[themeProvider.selectedThemeIndex][2],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
