import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_provider.dart';

class ShowroomPage extends StatelessWidget {
  const ShowroomPage({super.key});

  void _showImageContent(BuildContext context, Map<String, dynamic> imageData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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

    return Consumer<ImageProviderClass>(
      builder: (context, provider, child) {
        final selectedImages = provider.selectedImages;

        return Scaffold(
          appBar: AppBar(title: Text(languageProvider.getLanguage(message: "갤러리"))),
          body: selectedImages.isEmpty
              ? Center(child: Text(languageProvider.getLanguage(message: "갤러리가 비어있습니다")))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      final imageData = selectedImages[index];
                      return GestureDetector(
                        onTap: () => _showImageContent(context, imageData),
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
                ),
        );
      },
    );
  }
}
