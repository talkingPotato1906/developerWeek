import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeChanger extends StatelessWidget {

  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<String> themeNames = ["식물", "식기", "술", "원석"];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            dropdownColor: ColorPalette.palette[themeProvider.selectedThemeIndex]
                [1],
            borderRadius: BorderRadius.circular(10),
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
                  ),
                );
              },
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<ThemeProvider>().changeTheme(value);
              }
            },
          )
        ],
      ),
    );
  }
}
