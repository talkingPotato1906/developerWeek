import 'package:dv/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  final List<String> themeNames = ["식물", "식기", "술", "원석"];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('설정'),
          ),
          body: Container(
            color: ColorPalette.palette[themeProvider.selectedThemeIndex][0], // 배경색 적용
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "테마 선택",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  
                  // 🟢 드롭다운 버튼 UI 개선
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8), // 반투명 배경 추가
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300), // 테두리 추가
                    ),
                    child: DropdownButton<int>(
                      value: themeProvider.selectedThemeIndex,
                      underline: SizedBox(), // 🟢 밑줄 제거
                      items: List.generate(
                        themeNames.length,
                        (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Row(
                              children: [
                                Text(themeNames[index], style: TextStyle(fontSize: 16)),
                                SizedBox(width: 10),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.palette[index][0],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.palette[index][1],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.changeTheme(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

