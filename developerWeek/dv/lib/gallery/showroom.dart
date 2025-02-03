import 'package:dv/login/login_provider.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_provider.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  void _showImageContent(BuildContext context, Map<String, dynamic> imageData) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor:
              ColorPalette.palette[themeProvider.selectedThemeIndex][0],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Image.memory(
                          imageData["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(
                              imageData["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(imageData["content"]),
                          ],
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

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loginProvider = Provider.of<LogInProvider>(context);

    return Consumer<ImageProviderClass>(
      builder: (context, provider, child) {
        final selectedImages = provider.selectedImages;

        return Scaffold(
            appBar: AppBar(
              title: Text(languageProvider.getLanguage(message: "갤러리")),
              automaticallyImplyLeading: false,
            ),
            body: loginProvider.isLoggedIn
                ? selectedImages.isEmpty
                    ? Center(
                        child: Text(languageProvider.getLanguage(
                            message: "갤러리가 비어있습니다"),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),)
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            final imageData = selectedImages[index];
                            return GestureDetector(
                              onTap: () =>
                                  _showImageContent(context, imageData),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  imageData["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                : Center(
                    child: Text(languageProvider.getLanguage(
                        message: "로그인이 필요한 서비스입니다."),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ));
      },
    );
  }
}
