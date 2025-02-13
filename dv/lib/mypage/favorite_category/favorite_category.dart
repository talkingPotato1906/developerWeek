import 'package:dv/mypage/favorite_category/category_provider.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCategory extends StatefulWidget {
  const FavoriteCategory({super.key});

  @override
  _FavoriteCategoryState createState() => _FavoriteCategoryState();
}

class _FavoriteCategoryState extends State<FavoriteCategory> {
  bool isExpanded = false;

  final List<String> categoryOptions = ["식물", "식기", "원석", "주류", "책", "피규어"];

  @override
  Widget build(BuildContext context) {
    final languageProvider=Provider.of<LanguageProvider>(context);
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(20), //  패딩 값 20
        child: Row(
          children: [
            Text(
              languageProvider.getLanguage(message: "카테고리 즐겨찾기"),
               // 언어 선택
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 30,
            ),

            /// ✅ `DropdownButton`에서 하나의 카테고리만 선택하도록 변경
            DropdownButton<String>(
              hint: Text(languageProvider.getLanguage(message: "카테고리 선택")),
              value: categoryOptions.contains(categoryProvider.selectedCategory)
                  ? categoryProvider.selectedCategory
                  : categoryOptions.first, // ✅ 유효한 값인지 확인
              onChanged: (newValue) {
                if (newValue != null) {
                  categoryProvider.setCategory(newValue);
                }
              },
              items: categoryOptions.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(languageProvider.getLanguage(message: category)),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
