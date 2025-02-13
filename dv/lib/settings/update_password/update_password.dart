import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dv/settings/language/language_provider.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> updatePassword(String newPassword, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(languageProvider.getLanguage(message: "비밀번호가 성공적으로 변경되었습니다."))));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(languageProvider.getLanguage(message: "오류"))));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(labelText: languageProvider.getLanguage(message: "새 비밀번호")),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: languageProvider.getLanguage(message: "비밀번호 확인")),
            obscureText: true,
          ),
          const SizedBox(height: 20,),
          _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(ColorPalette.palette[themeProvider.selectedThemeIndex][3]),
              backgroundColor: WidgetStateProperty.all(ColorPalette.palette[themeProvider.selectedThemeIndex][2])
            ),
            onPressed: () {
            String newPassword = _newPasswordController.text.trim();
            String confirmPassword = _confirmPasswordController.text.trim();
            if (newPassword != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text( languageProvider.getLanguage(message: "비밀번호가 일치하지 않습니다."))),
              );
              return;
            }
            updatePassword(newPassword, context);
          }, child: Text(languageProvider.getLanguage(message: "비밀번호 변경")))
        ],
      )
    );

  }
}
