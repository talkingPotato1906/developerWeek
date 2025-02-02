//  포인트 상점 화면
import 'package:dv/login/login_provider.dart'; //  로그인 상태 감지
import 'package:dv/menu/menu.dart'; //  메뉴 버튼
import 'package:dv/settings/language/language_provider.dart'; //  언어 적용
import 'package:dv/settings/theme/color_palette.dart'; //  테마 적용
import 'package:dv/settings/theme/theme_provider.dart'; //  테마 적용
import 'package:dv/shop/shop_item_provider.dart'; //  상품 및 user 포인트 관리
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopItemProvider>(
        context); //  유저 포인트 상태 및 상품 구매 여부 Provider
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false); // 테마 적용
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false); //  언어 적용
    final loginProvider =
        Provider.of<LogInProvider>(context, listen: false); // 로그인 상태 감지

    return Scaffold(
      appBar: AppBar(title: Text("포인트 상점")),
      floatingActionButton: FloatingMenuButton(), //  메뉴 버튼
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: loginProvider.isLoggedIn
                ?
                //  로그인 상태일 때 보유 포인트 표시
                Text(
                    "보유 포인트: ${shopProvider.userPoints}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : SizedBox(), // 로그아웃 상태일 때 아무것도 표시하지 않음
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shopProvider.items.length, //  상품 개수
              itemBuilder: (context, index) {
                final itemName =
                    shopProvider.items.keys.elementAt(index); //  상품 이름
                final itemData =
                    shopProvider.items[itemName]!; // 상품 데이터 리스트(가격, 구매 여부)
                final isPurchased = itemData[2] as bool; // 구매 여부

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
                          "profile/$itemName.png", //  이미지 주소
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
                              "${itemData[1]} pt", //  가격 표시
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      loginProvider.isLoggedIn // 로그인 상태일 때 구매 아이콘 및 품절 여부 표시
                          ? isPurchased
                              // 구매 된 경우 품절 표시
                              ? Text(
                                  languageProvider.getLanguage(message: "품절"),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              //  구매 안 된 경우 구매 아이콘 표시
                              : GestureDetector(
                                  onTap: () {
                                    _showPurchaseDialog(
                                        context,
                                        itemName,
                                        itemData[0],
                                        itemData[1],
                                        languageProvider,
                                        themeProvider);
                                  },
                                  child: Icon(Icons.shopping_cart,
                                      color: ColorPalette.palette[
                                          themeProvider.selectedThemeIndex][3],
                                      size: 24),
                                )
                          //  로그아웃 상태인 경우 아이콘 및 품절 표시 하지 않음
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

  //  장바구니 버튼 눌렀을 경우 구매 확인 팝업창 표시 함수
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
              backgroundColor:
                  ColorPalette.palette[themeProvider.selectedThemeIndex][0],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "profile/$imagePath.png", //  이미지 경로
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  Text("가격: $price 포인트"), //  가격 표시
                ],
              ),
              actions: [
                //  취소 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel_outlined),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][1],
                      iconColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][0]),
                  onPressed: () => Navigator.pop(context), //  팝업 창 끄기
                  label: Text(
                    languageProvider.getLanguage(message: "취소"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorPalette
                            .palette[themeProvider.selectedThemeIndex][0]),
                  ),
                ),
                //  구매 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.shopping_bag),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][2],
                      iconColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][0]),
                  onPressed: () {
                    shopProvider
                        .purchaseItem(itemName); //  해당 아이템 구매 상태로 변경 및 포인트 차감
                    Navigator.pop(context); //  팝업창 닫기
                  },
                  label: Text(languageProvider.getLanguage(message: "구매"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][0])),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
