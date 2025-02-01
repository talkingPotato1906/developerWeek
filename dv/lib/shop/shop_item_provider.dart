import 'package:dv/shop/shop_items.dart';
import 'package:flutter/material.dart';

class ShopItemProvider extends ChangeNotifier {
  int _userPoints = 1000; // 초기 포인트 설정
  int get userPoints => _userPoints;

  Map<String, List<dynamic>> _items = ShopItemList.items;
  Map<String, List<dynamic>> get items => _items;

  void purchaseItem(String itemName) {
    if (_items.containsKey(itemName)) {
      int itemPrice = _items[itemName]![1] as int;
      bool isPurchased = _items[itemName]![2] as bool;

      if (!isPurchased && _userPoints >= itemPrice) {
        _userPoints -= itemPrice;
        _items[itemName]![2] = true; // 구매 상태 변경
        notifyListeners();
      }
    }
  }
}
