import 'package:dv/login/login_provider.dart';
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:dv/shop/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopItemProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final loginProvider = Provider.of<LogInProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("포인트 상점")),
      floatingActionButton: FloatingMenuButton(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: loginProvider.isLoggedIn
                ? Text(
                    "보유 포인트: ${shopProvider.userPoints}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : SizedBox(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shopProvider.items.length,
              itemBuilder: (context, index) {
                final itemName = shopProvider.items.keys.elementAt(index);
                final itemData = shopProvider.items[itemName]!;
                final isPurchased = itemData[2] as bool;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment(0.0, 0.7),
                              end: Alignment.centerRight,
                              colors: [Colors.white, Colors.transparent],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("profile/$itemName.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${itemData[1]} pt",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      loginProvider.isLoggedIn
                          ? isPurchased
                              ? Text(
                                  languageProvider.getLanguage(message: "품절"),
                                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _showPurchaseDialog(context, itemName, itemData[0], itemData[1], languageProvider, themeProvider);
                                  },
                                  child: Icon(Icons.shopping_cart,
                                      color: ColorPalette.palette[themeProvider.selectedThemeIndex][3], size: 24),
                                )
                          : SizedBox(),
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
      BuildContext context,
      String itemName,
      String imagePath,
      int price,
      LanguageProvider languageProvider,
      ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ShopItemProvider>(
          builder: (context, shopProvider, child) {
            return AlertDialog(
              backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.white, Colors.transparent],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      "profile/$imagePath.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("가격: $price 포인트"),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel_outlined),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][1],
                      iconColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0]),
                  onPressed: () => Navigator.pop(context),
                  label: Text(
                    languageProvider.getLanguage(message: "취소"),
                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorPalette.palette[themeProvider.selectedThemeIndex][0]),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.shopping_bag),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex][2],
                      iconColor: ColorPalette.palette[themeProvider.selectedThemeIndex][0]),
                  onPressed: () {
                    shopProvider.purchaseItem(itemName);
                    Navigator.pop(context);
                  },
                  label: Text(languageProvider.getLanguage(message: "구매"),
                      style: TextStyle(fontWeight: FontWeight.bold, color: ColorPalette.palette[themeProvider.selectedThemeIndex][0]))),
              ],
            );
          },
        );
      },
    );
  }
}
