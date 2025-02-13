import 'package:dv/gallery/recommend/recommend_screen.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "추천 페이지")),
      ),
      body: RecommendScreen(),
    );
  }
}
