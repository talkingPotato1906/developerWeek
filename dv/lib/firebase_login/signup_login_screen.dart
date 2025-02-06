import 'package:dv/firebase_login/signup_login.dart';
import 'package:dv/login/login_provider.dart';
import 'package:dv/login/login_success_page.dart';
import 'package:dv/sign_up/sign_up_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

// 🔹 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  String errorMessage = '';

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final loginProvider = Provider.of<LogInProvider>(context, listen: false);

    String? result = await authService.login(email, password);
    if (result != null && !result.contains("ERROR")) {
      loginProvider.login(email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginSuccessPage(email: email),
        ),
      );
    } else {
      setState(() => errorMessage = result ?? "로그인 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 왼쪽에 일러스트 이미지 추가
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/login/green.png",
                      fit: BoxFit.contain),
                ),
              ),

              // 🔹 오른쪽 로그인 폼
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Welcome!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "이메일",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "비밀번호",
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        if (errorMessage.isNotEmpty)
                          Text(errorMessage,
                              style: TextStyle(color: Colors.red)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: login,
                              child: Text("로그인"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text("회원가입"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 회원가입 화면
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  String errorMessage = '';

  void register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    String? result = await authService.register(email, password);
    if (result != null && !result.contains("ERROR")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpSuccessScreen(email: email)),
      );
    } else {
      setState(() => errorMessage = result ?? "회원가입 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "이메일"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: register,
              child: Text("회원가입"),
            ),
          ],
        ),
      ),
    );
  }
}
