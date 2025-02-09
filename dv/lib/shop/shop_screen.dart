//  포인트 상점 화면
import 'package:dv/login/login_provider.dart'; //  로그인 상태 감지
import 'package:dv/menu/menu.dart'; //  메뉴 버튼
import 'package:dv/settings/language/language_provider.dart'; //  언어 적용
import 'package:dv/settings/theme/color_palette.dart'; //  테마 적용
import 'package:dv/settings/theme/theme_provider.dart'; //  테마 적용
import 'package:dv/shop/shop_provider.dart'; //  상품 및 user 포인트 관리
import 'package:dv/shop/user_points_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    // 🔹 `initState()`에서 Firestore 데이터 불러오기
    Future.microtask(() {
      Provider.of<UserPointsProvider>(context, listen: false).fetchUserPoints();
    });
  }

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
            child: Consumer<LogInProvider>(
             builder: (context, loginProvider, child) {
             return Column(
               children: [
                 if (loginProvider.isLoggedIn)
                 Consumer<UserPointsProvider>(
                 builder: (context, provider, child) {
                 if (provider.isLoading) {
                  return Center(
                    child: Column(
                     children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("포인트 데이터를 불러오는 중입니다..."),
                    ],
                  ),
                );
              }
              return Container(
                width: double.infinity,
                height: 100,
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.confirmation_num_outlined,
                        size: 24, color: ColorPalette.palette[themeProvider.selectedThemeIndex][0]),
                    SizedBox(width: 8),
                    Text(
                      "보유 포인트: ${provider.points}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.palette[themeProvider.selectedThemeIndex][0],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
      ],
    );
  },
),

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

                return SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          ColorPalette.palette[themeProvider.selectedThemeIndex]
                              [1], // 아이템 전체 배경색
                      border: Border.all(
                        color: ColorPalette
                                .palette[themeProvider.selectedThemeIndex]
                            [0], // 테두리 색상
                        width: 2, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                    ),
                    //padding: EdgeInsets.all(12), // 내부 패딩 추가
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 이미지 (leading)
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment(0.2, 0.0),
                                end: Alignment(0.9, 0.0),
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
                            ), // 이미지를 꽉 차게 조정
                          ),
                        ),
                        const SizedBox(width: 50), // 이미지와 텍스트 간격
                        // 텍스트 (title, subtitle)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 가격 표시 컨테이너
                              Container(
                                width: double.infinity,
                                height: 50,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorPalette.palette[
                                      themeProvider.selectedThemeIndex][1],
                                ),
                                child: Text(
                                  "${itemData[1]} pt", //  가격 표시
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        loginProvider.isLoggedIn
                            ? isPurchased
                                // 🔹 구매 완료된 경우
                                ? Text(
                                    "품절", // 🔹 언어 프로바이더 제거 및 직접 텍스트 표시
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                // 🔹 구매 가능한 경우
                                : GestureDetector(
                                    onTap: () {
                                      _showPurchaseDialog(
                                        context,
                                        itemName,
                                        itemData[0],
                                        itemData[1],
                                        languageProvider,
                                        themeProvider,
                                      );
                                    },
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ColorPalette.palette[
                                          themeProvider.selectedThemeIndex][3],
                                      size: 30,
                                    ),
                                  )
                            : SizedBox(), // 🔹 로그아웃 상태일 경우 아무것도 표시하지 않음
                      ],
                    ),
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
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipOval(
                      // 이미지를 동그랗게 자름
                      child: Image.asset(
                        "profile/$itemName.png", // 이미지 주소
                        fit: BoxFit.cover, // 이미지를 꽉 차게 조정
                      ),
                    ),
                  ), //  가격 표시
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
                  icon: Icon(Icons.shopping_bag_outlined),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][2],
                      iconColor: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][0]),
                  onPressed: () {
                    bool isPurchased = shopProvider.purchaseItem(
                        context, itemName) as bool; // 구매 시도

                    if (isPurchased) {
                      Navigator.pop(context); // 구매 성공 시에만 팝업창 닫기
                    }
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
