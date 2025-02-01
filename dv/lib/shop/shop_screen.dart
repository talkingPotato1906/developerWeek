import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'shop_item_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("포인트 상점")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "보유 포인트: ${shopProvider.userPoints}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shopProvider.items.length,
              itemBuilder: (context, index) {
                final itemName = shopProvider.items.keys.elementAt(index);
                final itemData = shopProvider.items[itemName]!;
                final isPurchased = itemData[2] as bool;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 이미지 (leading)
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          "profile/$itemName.png",
                          fit: BoxFit.fill, // 이미지 영역 꽉 채우기
                        ),
                      ),
                      const SizedBox(width: 16), // 이미지와 텍스트 간격
                      // 텍스트 (title, subtitle)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${itemData[1]} 포인트",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // trailing (품절 표시)
                      isPurchased
                          ? Text(
                              "품절",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            )
                          : GestureDetector(
                              onTap: () {
                                _showPurchaseDialog(context, itemName,
                                    itemData[0], itemData[1]);
                              },
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.green, size: 24),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
      BuildContext context, String itemName, String imagePath, int price) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ShopItemProvider>(
          builder: (context, shopProvider, child) {
            return AlertDialog(
              title: Text(itemName),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "profile/$imagePath.png",
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  Text("가격: $price 포인트"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("취소"),
                ),
                ElevatedButton(
                  onPressed: () {
                    shopProvider.purchaseItem(itemName);
                    Navigator.pop(context);
                  },
                  child: Text("구매"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
