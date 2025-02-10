import 'package:dv/firebase_login/signup_login_screen.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpSuccessScreen extends StatefulWidget {
  final String email;

  const SignUpSuccessScreen({super.key, required this.email});

  @override
  _SignUpSuccessPageState createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "회원가입 성공")),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageProvider.getLanguage(message: "환영합니다."),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(
                  "${widget.email}!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ColorPalette.palette[themeProvider.selectedThemeIndex][2],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              child: Text(
                languageProvider.getLanguage(message: "로그인 페이지로 이동"),
                style: TextStyle(
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                      [0],
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
