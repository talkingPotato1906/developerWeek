import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> updatePassword(String newPassword) async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("비밀번호가 성공적으로 변경되었습니다."))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생"))
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(labelText: "새 비밀번호"),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: "비밀번호 확인"),
            obscureText: true,
          ),
          const SizedBox(height: 20,),
          _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : ElevatedButton(onPressed: () {
            String newPassword = _newPasswordController.text.trim();
            String confirmPassword = _confirmPasswordController.text.trim();
            if (newPassword != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
              );
              return;
            }
            updatePassword(newPassword);
          }, child: Text("비밀번호 변경"))
        ],
      )
    );
  }
}
