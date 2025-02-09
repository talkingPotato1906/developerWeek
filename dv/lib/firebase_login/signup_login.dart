import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  // 회원가입
  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "nickname": email,
        "points": 0,
        "posts": [],
        "gallery": [],
        "following": [],
        "profile": "assets/profile/default.png",
        "trophy": ["새싹"],
        "purchasedItem": ["assets/profile/default.png"],
        "profileIdx": 0,
        "trophyIdx": 0,
        "category": 0,
      });
      return uid;
    } catch (e) {
      return "ERROR: ${e.toString()}";
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
      return "ERROR: ${e.toString()}";
    }
  }

  // 로그아웃
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();

      final loginProvider = context.read<LogInProvider>();
      loginProvider.logout();

      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

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
  

