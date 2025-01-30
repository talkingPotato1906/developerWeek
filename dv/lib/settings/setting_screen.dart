import 'package:dv/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  final List<String> themeNames = ["식물", "식기", "술", "원석"];

  

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('설정'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "테마 선택",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              // 테마 변경 드롭다운 버튼
              DropdownButton<int>(
                value: themeProvider.selectedThemeIndex,
                items: List.generate(
                  themeNames.length,
                  (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Row(
                        children: [
                          Text(themeNames[index]),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: ColorPalette.palette[index][0],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: ColorPalette.palette[index][1],
                                borderRadius: BorderRadius.circular(5)),
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
              )
            ],
          ),
        ));
  }
}
