//  각 테마에 사용할 색상 팔레트
import 'package:flutter/material.dart';

class ColorPalette {
  static const List<List<Color>> palette = [
    // 식물 테마에 사용할 색상 팔레트
    [
      Color(0xFF123524),
      Color.fromARGB(255, 31, 80, 14),
      Color.fromARGB(255, 79, 104, 37),
      Color(0xFFefe3c2),
    ],

    // 식기 테마에 사용할 색상 팔레트
    [
      Color(0xFFfffdf0),
      Color.fromARGB(255, 219, 219, 196),
      Color.fromARGB(255, 198, 201, 174),
      Color.fromARGB(255, 68, 43, 29)
    ],

    // 술 테마에 사용할 색상 팔레트
    [
      Color.fromARGB(255, 26, 26, 26),
      Color.fromARGB(255, 70, 17, 34),
      Color.fromARGB(255, 104, 41, 55),
      Color.fromARGB(255, 179, 160, 166),
    ],

    // 원석 테마에 사용할 색상 팔레트
    [
      Color(0xFFfbfbfb),
      Color.fromARGB(255, 202, 217, 223),
      Color.fromARGB(255, 160, 176, 207),
      Color.fromARGB(255, 162, 152, 209)
    ]
  ];
}
