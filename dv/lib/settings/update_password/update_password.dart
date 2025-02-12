import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> updatePassword(String newPassword) async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("비밀번호가 성공적으로 변경되었습니다.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("오류 발생")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                  labelText: "새 비밀번호",
                  labelStyle: TextStyle(
                    color: ColorPalette
                        .palette[themeProvider.selectedThemeIndex][4],
                  ),
                  enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        ColorPalette.palette[themeProvider.selectedThemeIndex][3], // 원하는 색상으로 변경
// 테두리 두께 조정 가능
                  ),
                  borderRadius: BorderRadius.circular(10.0), // 둥글게 만들고 싶다면 추가
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        ColorPalette.palette[themeProvider.selectedThemeIndex][2], // 포커스 상태일 때의 색상 변경

                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),),
              obscureText: true,
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: "비밀번호 확인",
                labelStyle: TextStyle(
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                      [4],
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        ColorPalette.palette[themeProvider.selectedThemeIndex][3], // 원하는 색상으로 변경
                    width: 2.0, // 테두리 두께 조정 가능
                  ),
                  borderRadius: BorderRadius.circular(10.0), // 둥글게 만들고 싶다면 추가
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        ColorPalette.palette[themeProvider.selectedThemeIndex][2], // 포커스 상태일 때의 색상 변경
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      String newPassword = _newPasswordController.text.trim();
                      String confirmPassword =
                          _confirmPasswordController.text.trim();
                      if (newPassword != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
                        );
                        return;
                      }
                      updatePassword(newPassword);
                    },
                    child: Text("비밀번호 변경"))
          ],
        ));
  }
}
