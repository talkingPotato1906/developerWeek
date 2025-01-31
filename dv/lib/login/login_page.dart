import 'package:dv/login/login_provider.dart';
import 'package:dv/login/login_success_page.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      final loginProvider = Provider.of<LogInProvider>(context, listen: false);
      final languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);

      if (email == "test@example.com" && password == "123456") {
        loginProvider.login(email);

        // ✅ 로그인 성공 시 새로운 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginSuccessPage(email: email)),
        );
      } else {
        // ✅ 로그인 실패 시 UI를 갱신하고 입력창을 다시 활성화
        setState(() {
          emailController.clear();
          passwordController.clear();
        });

        Future.delayed(Duration(milliseconds: 300), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(languageProvider.getLanguage(message: "로그인 실패")),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.getLanguage(message: "로그인"))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: languageProvider.getLanguage(message: "이메일"),
                    labelStyle: TextStyle(
                        color: themeProvider
                            .getTheme()
                            .textTheme
                            .bodyMedium
                            ?.color),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][3]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][3]),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return languageProvider.getLanguage(
                          message: "이메일을 입력하세요");
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: languageProvider.getLanguage(message: "비밀번호"),
                    labelStyle: TextStyle(
                        color: themeProvider
                            .getTheme()
                            .textTheme
                            .bodyMedium
                            ?.color),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][3]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][3]),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return languageProvider.getLanguage(
                          message: "비밀번호를 입력하세요");
                    }
                    return null;
                  },
                ),
                SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][3],
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: Text(
                    languageProvider.getLanguage(message: "로그인"),
                    style: TextStyle(
                      color: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][0],
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
