import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        return await pickedFile.readAsBytes();
      } else {
        return pickedFile.path;
      }
    }
    return null;
  }

  Future<String?> uploadImage(dynamic imageFile) async {
    try {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child("post_images/$fileName.jpg");

      UploadTask uploadTask;
      if (imageFile is File) {
        uploadTask = ref.putFile(imageFile);
      } else if (imageFile is Uint8List) {
        uploadTask = ref.putData(imageFile);
      } else {
        return null;
      }

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("이미지 업로드 오류: $e");
      return null;
    }
  }

  Future<void> uploadPost({
    required String title,
    required String content,
    required dynamic imageFile,
    required String category, // ✅ 카테고리 추가
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      String postId = uid + DateTime.now().millisecondsSinceEpoch.toString();
      String? imageUrl;

      if (imageFile != null && imageFile is! String) {
        imageUrl = await uploadImage(imageFile);
      } else {
        imageUrl = imageFile;
      }

      await _firestore.collection("posts").doc(postId).set({
        "title": title,
        "content": content,
        "imageUrl": imageUrl ?? "",
        "uid": uid,
        "category": category, // ✅ 카테고리 저장
        "createdAt": Timestamp.now(),
        "reactions": 0,
        "reacted": [],
        "is_added_to_gallery": false,
      });

      DocumentReference userRef = _firestore.collection("users").doc(uid);

      await userRef.update({
        "posts": FieldValue.arrayUnion([postId])
      });
    } catch (e) {
      print("게시글 업로드 오류: $e");
    }
  }
}
