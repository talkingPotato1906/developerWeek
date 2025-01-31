import 'package:dv/login/login_page.dart';
import 'package:dv/main.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/setting_screen.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingMenuButton extends StatefulWidget {
  const FloatingMenuButton({super.key});

  @override
  _FloatingMenuButtonState createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      children: [
        if (_isMenuOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: ColorPalette.palette[themeProvider.selectedThemeIndex][0].withAlpha(100),
              width: screenWidth,
              height: screenHeight,
            ),
          ),
        Positioned(
          top: 50,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 메뉴 버튼 누르면 메뉴 목록 보여주기
              if (_isMenuOpen) _buildMenu(context),
              FloatingActionButton(
                heroTag: "menu",
                onPressed: _toggleMenu,
                child: Icon(_isMenuOpen ? Icons.close : Icons.menu),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeProvider.getTheme().scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 메뉴 아이템 생성
          _buildMenuItem(Icons.home, languageProvider.getLanguage(message: "홈"),
              () {
            _toggleMenu();
            if (mounted && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            }
          }),
          _buildMenuItem(
              Icons.settings, languageProvider.getLanguage(message: "설정"), () {
            _toggleMenu();
            if (mounted && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            }
          }),
          _buildMenuItem(
              Icons.sell, languageProvider.getLanguage(message: "포인트 상점"), () {
            print("포인트 상점");
          }),
          _buildMenuItem(
              Icons.logout, languageProvider.getLanguage(message: "로그아웃"), () {
            _toggleMenu();
            if (mounted && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          }),
        ],
      ),
    );
  }

  // 메뉴 아이템 생성
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon,
                color: themeProvider.getTheme().textTheme.bodyLarge!.color),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
