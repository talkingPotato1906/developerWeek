//  설정에서 테마를 변환하기 위한 드롭박스
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);  // 테마 적용
    final languageProvider = Provider.of<LanguageProvider>(context);  // 언어 적용
    //  각 언어별 테마 이름 리스트
    final List<List<String>> themeNames = [
      ["Plant", "Cutlery", "Liquor", "Gemstone"],
      ["식물", "식기", "주류", "원석"],
      ["植物", "食器", "酒", "宝石"],
      ["植物", "餐具", "酒", "宝石"],
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            languageProvider.getLanguage(message: "테마 선택"), // 테마 선택
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: 30,
          ),
          // 테마 변경 드롭다운 버튼
          DropdownButton<int>(
            dropdownColor:
                ColorPalette.palette[themeProvider.selectedThemeIndex][1],
            borderRadius: BorderRadius.circular(10),
            value: themeProvider.selectedThemeIndex,  //  현재 선택한 테마가 드롭다운에 보이도록
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
                      //  샘플 컬러 2개
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorPalette.palette[index][0],
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
            //  선택한 테마 반영
            onChanged: (value) {
              if (value != null) {
                context.read<ThemeProvider>().changeTheme(value);
              }
            },
            //  선택한 테마가 드롭박스 창에서 보이도록
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
