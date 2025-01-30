import 'package:dv/color_palette.dart';
import 'package:dv/settings/setting_screen.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingMenuButton extends StatefulWidget {
  const FloatingMenuButton({Key? key}) : super(key: key);

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
              color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
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
              if (_isMenuOpen) _buildMenu(context),
              FloatingActionButton(
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
          _buildMenuItem(Icons.home, "홈", () {
            print("홈 클릭");
          }),
          _buildMenuItem(Icons.settings, "설정", () {
            _toggleMenu();
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              }
            });
          }),
          _buildMenuItem(Icons.logout, "로그아웃", () {
            print("로그아웃 클릭");
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: themeProvider.getTheme().textTheme.bodyLarge!.color),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

