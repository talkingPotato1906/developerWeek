//  user 포인트 상태와 item의 구매 여부를 제공하는 Provider
import 'package:dv/shop/shop_items.dart'; // 상품 리스트
import 'package:flutter/material.dart';

class ShopItemProvider extends ChangeNotifier {
  int _userPoints = 1000; // 초기 포인트 설정
  int get userPoints => _userPoints;

  final Map<String, List<dynamic>> _items = ShopItemList.items; // 맵 불러오기
  Map<String, List<dynamic>> get items => _items;

  //  아이템 구매 시 상태 변경
  void purchaseItem(String itemName) {
    if (_items.containsKey(itemName)) {
      int itemPrice = _items[itemName]![1] as int;
      bool isPurchased = _items[itemName]![2] as bool;

      if (!isPurchased && _userPoints >= itemPrice) {
        _userPoints -= itemPrice; //  user 포인트에서 가격만큼 포인트 차감
        _items[itemName]![2] = true; // 구매 상태 변경
        notifyListeners();
      }
    }
  }
}
