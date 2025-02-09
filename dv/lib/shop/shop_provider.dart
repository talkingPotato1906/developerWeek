import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/shop/shop_items.dart'; // 상품 리스트
import 'package:dv/shop/user_points_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopItemProvider extends ChangeNotifier {
  int _userPoints = 0; // 초기 포인트
  final Map<String, List<dynamic>> _items = ShopItemList.items;
  String? _userId; // 현재 로그인한 유저 ID

  int get userPoints => _userPoints;
  Map<String, List<dynamic>> get items => _items;

  // 🔹 Firestore에서 유저 포인트 불러오기
  Future<void> initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userId = user.uid; // 로그인한 유저 ID 저장
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (userDoc.exists) {
      _userPoints = userDoc["points"] ?? 0; // 포인트 가져오기

      // 🔹 구매한 아이템 목록 가져오기
      List<dynamic> purchasedItems = userDoc["purchasedItems"] ?? [];
      for (String itemName in purchasedItems) {
        if (_items.containsKey(itemName)) {
          _items[itemName]![2] = true; // 🔹 구매 상태를 "품절"로 변경
        }
      }

      notifyListeners(); // UI 업데이트
    }
  }

  Future<void> updateUserPoints(int newPoints) async {
    if (_userId == null) return;

    try {
      await FirebaseFirestore.instance.collection("users").doc(_userId).update({
        "points": newPoints,
      });

      // 🔹 Firestore에서 최신 포인트 가져오기 (UI 반영)
      await initialize();

      print("✅ Firestore에서 포인트 업데이트 완료: $_userPoints");
    } catch (e) {
      print("🔥 Firestore에서 포인트 업데이트 실패: $e");
    }
  }

  // 🔹 아이템 구매 처리 (Firestore 업데이트 후 UI 반영)
  Future<bool> purchaseItem(BuildContext context, String itemName) async {
    if (_items.containsKey(itemName)) {
      int itemPrice = _items[itemName]![1] as int;
      bool isPurchased = _items[itemName]![2] as bool;

      final userPointsProvider =
          Provider.of<UserPointsProvider>(context, listen: false);

      // 🔹 Firestore에서 최신 포인트 가져오기
      await userPointsProvider.fetchUserPoints();
      int currentPoints = userPointsProvider.points;

      if (!isPurchased && currentPoints >= itemPrice) {
        try {
          // 🔹 Firestore에서 포인트 차감
          await userPointsProvider.updateUserPoints(currentPoints - itemPrice);

          // 🔹 Firestore에 구매한 아이템 기록
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              "purchasedItems": FieldValue.arrayUnion([itemName]), // 🔹 아이템 추가
            });
          }

          // 🔹 구매 상태 업데이트
          _items[itemName]![2] = true;
          notifyListeners(); // UI 업데이트

          // 🔹 구매 성공 후 다이얼로그 닫기
          Navigator.pop(context);

          print("✅ $itemName 구매 성공! 남은 포인트: ${userPointsProvider.points}");
          return true;
        } catch (e) {
          print("🔥 Firestore에서 아이템 구매 실패: $e");
          return false;
        }
      } else if (!isPurchased && currentPoints < itemPrice) {
        _showInsufficientPointsDialog(context);
        return false;
      }
    }
    return false;
  }

  // 🔹 포인트 부족 경고창
  void _showInsufficientPointsDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              ColorPalette.palette[themeProvider.selectedThemeIndex][0],
          title: Text(
            "포인트 부족",
            style: TextStyle(
                color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                    [2]),
          ),
          content: Text(
            "포인트가 부족하여 아이템을 구매할 수 없습니다.",
            style: TextStyle(
                color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                    [3]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                "확인",
                style: TextStyle(
                    color: ColorPalette
                        .palette[themeProvider.selectedThemeIndex][2]),
              ),
            ),
          ],
        );
      },
    );
  }
}
