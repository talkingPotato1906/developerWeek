//이미지 UI & 클릭 이벤트
import 'package:flutter/material.dart';

import 'show_image_dialog.dart';

Widget showroomGridItem(BuildContext context, Map<String, dynamic> imageData) {
  return GestureDetector(
    onTap: () => showImageContent(context, imageData),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.memory(
        imageData["image"],
        fit: BoxFit.cover,
      ),
    ),
  );
}
