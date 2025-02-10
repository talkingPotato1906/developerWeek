import 'package:dv/firebase_login/signup_login.dart';
import 'package:dv/login/login_provider.dart';
import 'package:dv/login/login_success_page.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_images.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/sign_up/sign_up_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



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

    String? result = await authService.login(email, password, context);
    if (result != null && !result.contains("ERROR")) {
      loginProvider.login(email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginSuccessPage(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeColors = ColorPalette.palette[themeProvider.selectedThemeIndex];

    return Scaffold(
      backgroundColor: themeColors[0], // 배경색 변경
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 테마별 이미지 위젯 사용 (새 파일에서 불러옴)
              const Expanded(
                flex: 1,
                child: ThemedImageWidget(),
              ),

              // 🔹 로그인 폼
              Expanded(
                flex: 1,
                child: Card(
                  color: themeColors[1], // 카드 배경색 적용
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: themeColors[3])),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColors[2], // 버튼 색상 변경
                              ),
                              onPressed: login,
                              child: Text("로그인",
                                  style: TextStyle(color: themeColors[3])),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColors[2], // 버튼 색상 변경
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text("회원가입",
                                  style: TextStyle(color: themeColors[3])),
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

// 🔹 회원가입 화면 (여기에 추가)
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeColors = ColorPalette.palette[themeProvider.selectedThemeIndex];

    return Scaffold(
      backgroundColor: themeColors[0], // 배경색 적용
      appBar: AppBar(
        title: Text("회원가입", style: TextStyle(color: themeColors[3])),
        backgroundColor: themeColors[1],
      ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColors[2], // 버튼 색상 변경
              ),
              onPressed: register,
              child: Text("회원가입", style: TextStyle(color: themeColors[3])),
            ),
          ],
        ),
      ),
    );
  }
}
