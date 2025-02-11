import 'package:dv/mypage/favorite_category/category_provider.dart';
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
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "즐겨찾기 카테고리",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoryProvider.selectedCategory,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          /// ✅ `DropdownButton`에서 하나의 카테고리만 선택하도록 변경
                          DropdownButton<String>(
                            hint: Text("카테고리 선택"),
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
                                child: Text(category),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),

                          /// ✅ 버튼을 누르면 선택된 카테고리 변경
                          ElevatedButton(
                            onPressed: () {
                              if (categoryOptions.contains(categoryProvider.selectedCategory)) {
                                categoryProvider.setCategory(categoryProvider.selectedCategory);
                              }
                            },
                            child: Text("카테고리 설정"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
