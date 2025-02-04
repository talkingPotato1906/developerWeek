//이미지 클릭 시 상세 보기(내용) 창
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showImageContent(BuildContext context, Map<String, dynamic> imageData) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: ColorPalette.palette[themeProvider.selectedThemeIndex]
            [0],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 왼쪽: 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35, // 화면의 35% 차지
                  height: MediaQuery.of(context).size.height * 0.7, // 세로 크기
                  child: Image.memory(
                    imageData["image"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 16.0), // 이미지와 텍스트 사이 간격

              // ✅ 오른쪽: 제목 & 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      imageData["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          imageData["content"],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
