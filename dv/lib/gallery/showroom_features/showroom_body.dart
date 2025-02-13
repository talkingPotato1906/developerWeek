//갤러리 UI 구성
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../image_provider.dart';
import 'showroom_grid_item.dart';



Widget showroomBody(BuildContext context) {
  final provider = Provider.of<ImageProviderClass>(context);
  final languageProvider=Provider.of<LanguageProvider>(context);
  final selectedImages = provider.selectedImages;

  if (selectedImages.isEmpty) {
    return Center(
      child: Text(
        languageProvider.getLanguage(message: languageProvider.getLanguage(message: "전시할 게시물이 없습니다.")),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      )
    );
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, index) {
        return showroomGridItem(context, selectedImages[index]);
      },
    ),
  );
}
