import 'dart:convert';
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../authentication/signup.dart'; // 회원가입 화면 연결

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoggedIn = false; // 로그인 상태 저장

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final languageProvider = Get.find<LanguageProvider>();

    try {
      var response = await http.post(
        Uri.parse("https://yourserver.com/api/login.php"),
        body: {"email": email, "password": password},
      );

      var data = jsonDecode(response.body);
      if (data["success"]) {
        setState(() => _isLoggedIn = true); // 로그인 상태 업데이트
        Get.offNamed('/home'); // 로그인 성공 시 홈 화면 이동
      } else {
        _showErrorMessage(languageProvider.getLanguage(message: "로그인 실패"));
      }
    } catch (e) {
      _showErrorMessage(languageProvider.getLanguage(message: "네트워크 오류"));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Get.find<LanguageProvider>();
    final themeProvider = Get.find<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.getLanguage(message: "로그인"))),
      floatingActionButton: FloatingMenuButton(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration:
                      _inputDecoration("이메일", themeProvider, languageProvider),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty
                      ? languageProvider.getLanguage(message: "이메일을 입력하세요")
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration:
                      _inputDecoration("비밀번호", themeProvider, languageProvider),
                  obscureText: true,
                  validator: (value) => value!.isEmpty
                      ? languageProvider.getLanguage(message: "비밀번호를 입력하세요")
                      : null,
                ),
                SizedBox(height: 28),
                _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _customButton("로그인", _login, themeProvider, 3),
                          SizedBox(width: 30),
                          _customButton(
                              "회원가입",
                              () => Get.to(() => SignUpScreen()),
                              themeProvider,
                              2),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return InputDecoration(
      labelText: languageProvider.getLanguage(message: label),
      labelStyle: TextStyle(
          color: themeProvider.getTheme().textTheme.bodyMedium?.color),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: ColorPalette.palette[themeProvider.selectedThemeIndex][3]),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: ColorPalette.palette[themeProvider.selectedThemeIndex][2]),
      ),
    );
  }

  Widget _customButton(String text, VoidCallback onPressed,
      ThemeProvider themeProvider, int colorIndex) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex]
            [colorIndex],
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(
        Get.find<LanguageProvider>().getLanguage(message: text),
        style: TextStyle(
          color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
          fontSize: 18,
        ),
      ),
    );
  }
}
