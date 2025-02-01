import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_item_provider.dart';

class ShopScreen extends StatelessWidget {
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

                return ListTile(
                  leading: Image.asset("profile/${itemName}.png", width: 50),
                  title: Text(itemName),
                  subtitle: Text("${itemData[1]} 포인트"),
                  trailing: isPurchased ? Text("품절", style: TextStyle(color: Colors.red)) : null,
                  onTap: isPurchased
                      ? null
                      : () {
                          _showPurchaseDialog(context, itemName, itemData[0], itemData[1]);
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String itemName, String imagePath, int price) {
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
                  Image.asset("profile/$imagePath.png", width: 100),
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
