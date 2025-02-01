import 'package:dv/shop/shop_image.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  String nickname="nickname"; //유저 닉네임(입력받으면 바꿔야 함)
  int point=0; //포인트 초기값 설정



  @override
  Widget build(BuildContext context) {

    final imageSize = MediaQuery.of(context).size.width / 10;

    return Scaffold(

      appBar: AppBar(
        title: Text("포인트 상점"),
        centerTitle: true,
        elevation: 1.0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100.0, top: 70.0),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: imageSize,
                  ),
                  SizedBox(width: 12,),
                  Text(
                    nickname,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0), //컨테이너 내부 패딩 추가
                child: Text(
                  "보유 포인트 :\t$point pt",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListView(
                shrinkWrap: true,
                children: [
                const ShopImage(),
                ],
            ),

          ],
        ),
      ),
    );
  }
}
