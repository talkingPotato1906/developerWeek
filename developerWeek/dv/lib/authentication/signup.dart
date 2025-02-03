import 'dart:convert';
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    try {
      var response = await http.post(
        Uri.parse("https://your-api-url.com/signup"),
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Fluttertoast.showToast(msg: '회원가입 성공!');
          Navigator.pushReplacementNamed(context, '/signup_success',
              arguments: emailController.text);
        } else {
          Fluttertoast.showToast(msg: responseBody['message'] ?? '회원가입 실패');
        }
      } else {
        Fluttertoast.showToast(msg: '서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar:
          AppBar(title: Text(languageProvider.getLanguage(message: "회원가입"))),
      floatingActionButton: FloatingMenuButton(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: languageProvider.getLanguage(message: "이메일"),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty
                    ? languageProvider.getLanguage(message: "이메일을 입력하세요")
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: languageProvider.getLanguage(message: "비밀번호"),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? languageProvider.getLanguage(message: "비밀번호를 입력하세요")
                    : null,
              ),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                child: Text(languageProvider.getLanguage(message: "회원가입")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
