//  user 포인트 상태와 item의 구매 여부를 제공하는 Provider
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/shop/shop_items.dart'; // 상품 리스트
import 'package:dv/sign_up/account_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopItemProvider extends ChangeNotifier {
  int _userPoints = AccountList.userPoint["test@example.com"]!; // 초기 포인트 설정
  int get userPoints => _userPoints;

  final Map<String, List<dynamic>> _items = ShopItemList.items; // 맵 불러오기
  Map<String, List<dynamic>> get items => _items;

  //  아이템 구매 시 상태 변경
  bool purchaseItem(BuildContext context, String itemName) {
  if (_items.containsKey(itemName)) {
    int itemPrice = _items[itemName]![1] as int;
    bool isPurchased = _items[itemName]![2] as bool;

    if (!isPurchased && _userPoints >= itemPrice) {
      _userPoints -= itemPrice; // 포인트 차감
      _items[itemName]![2] = true; // 구매 상태 변경
      notifyListeners();
      return true; // 구매 성공
    } else if (!isPurchased && _userPoints < itemPrice) {
      _showInsufficientPointsDialog(context); // 포인트 부족 경고창
      return false; // 구매 실패
    }
  }
  return false; // 아이템이 존재하지 않음
}

}

// 포인트 부족 경고창
void _showInsufficientPointsDialog(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex]
            [0],
        title: Text(
          "포인트 부족",
          style: TextStyle(
              color: ColorPalette.palette[themeProvider.selectedThemeIndex][2]),
        ),
        content: Text("포인트가 부족하여 아이템을 구매할 수 없습니다.",
            style: TextStyle(
                color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                    [3])),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: Text(
              "확인",
              style: TextStyle(
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                      [2]),
            ),
          ),
        ],
      );
    },
  );
}
