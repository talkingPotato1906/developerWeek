import 'package:dv/firebase_login/signup_login.dart';
import 'package:dv/login/login_provider.dart';
import 'package:dv/login/login_success_page.dart';
import 'package:dv/sign_up/sign_up_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
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
        MaterialPageRoute(builder: (context) => LoginSuccessPage(email: email,)),
      );
    } else {
      setState(() => errorMessage = result ?? "로그인 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: login,
                  child: Text("로그인"),
                ),
                ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("회원가입"),
            ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

// 🔹 회원가입 화면
class RegisterScreen extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => SignUpSuccessScreen(email: email)),
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