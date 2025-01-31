import 'package:flutter/material.dart';

class ColorPalette {
  
  static const List<List<Color>> palette = [
    // 식물 테마에 사용할 색상 팔레트
    [
      Color(0xFF123524),
      Color(0xFF3e7b27),
      Color(0xFF85a947),
      Color(0xFFefe3c2)
    ],

    // 식기 테마에 사용할 색상 팔레트
    [
      Color(0xFFd9dfc6),
      Color(0xFFfffdf0),
      Color(0xFFeff3ea),
      Color.fromARGB(255, 68, 43, 29)
      
    ],

    // 술 테마에 사용할 색상 팔레트
    [
      Color(0xFF09122c),
      Color(0xFF872341),
      Color.fromARGB(255, 196, 69, 86),
      Color(0xFFe17564)
    ],

    // 원석 테마에 사용할 색상 팔레트
    [Color(0xFFa7e6ff), Color(0xFF3abef9),Color.fromARGB(255, 78, 128, 228), Color(0xFF050c9c)]
  ];
}
