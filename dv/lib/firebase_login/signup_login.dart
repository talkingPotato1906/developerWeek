import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 회원가입
  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      return e.toString();
    }
  }

  // 로그인
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      return e.toString();
    }
  }

  // FastAPI 보호된 API 요청
  Future<String> accessProtectedAPI() async {
    User? user = _auth.currentUser;
    if (user == null) return "No user logged in";

    String? token = await user.getIdToken();
    var response = await http.get(
      Uri.parse("http://localhost:8000/protected"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["message"];
    } else {
      return "Access denied";
    }
  }
}
