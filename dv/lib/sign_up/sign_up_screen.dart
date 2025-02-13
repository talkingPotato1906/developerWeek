import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/sign_up/sign_up_rules.dart';
import 'package:dv/sign_up/sign_up_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // FocusNode를 변수로 저장하여 상태 유지
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

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
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 이메일 입력창
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode, // FocusNode 적용
                  decoration: InputDecoration(
                    labelText: languageProvider.getLanguage(message: "이메일"),
                    labelStyle: TextStyle(

                        color: themeProvider
                        .getTheme()
                        .textTheme
                        .bodyMedium?.color
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][3],
                              width: 1.5
                              ),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(

                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][2],
                              width: 2.0
                              ),

                        
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
                // 비밀번호 입력창
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode, // FocusNode 적용
                  decoration: InputDecoration(
                    labelText: languageProvider.getLanguage(message: "비밀번호"),
                    labelStyle: TextStyle(
                      color:
                          themeProvider.getTheme().textTheme.bodyMedium?.color,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFefe3c2), // 기본 테두리 색상 (테스트용)
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFefe3c2), // 포커스 시 테두리 색상
                        width: 2.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                
                SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    String signUpMessage = signUpRules(emailController.text,
                            passwordController.text.toLowerCase())
                        .keys
                        .first;
                    bool signUpSuccess = signUpRules(emailController.text,
                        passwordController.text.toLowerCase())[signUpMessage]!;

                    if (signUpSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpSuccessScreen(
                                email: emailController.text)),
                      );
                    } else {
                      setState(() {
                        emailController.clear();
                        passwordController.clear();
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(languageProvider.getLanguage(
                                message: signUpMessage)),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][3],
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: Text(
                    languageProvider.getLanguage(message: "회원 가입"),
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
