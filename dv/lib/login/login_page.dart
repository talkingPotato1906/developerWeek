import 'package:flutter/material.dart';

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

      // 로그인 로직 (예: Firebase, API 요청)
      if (email == "test@example.com" && password == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 성공")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 실패, 이메일 또는 비밀번호 확인")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "이메일"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이메일을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호를 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: Text("로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
