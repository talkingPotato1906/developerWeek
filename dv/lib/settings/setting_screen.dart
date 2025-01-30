import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/language/language_changer.dart';
import 'package:dv/settings/theme/theme_changer.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  
  SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Container(
        color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
        child: SingleChildScrollView(
          child: Column(
            children: [
              ThemeChanger(),
              LanguageChanger()
            ],
          ),
        )
        ),
      );
    
  }
}
