import 'package:dv/settings/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'image_provider.dart'; // ImageProviderClass 추가

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageAndComment() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      final Map<String, String>? result = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          TextEditingController titleController = TextEditingController();
          TextEditingController contentController = TextEditingController();
          return AlertDialog(
            title: Text("제목과 내용 입력"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "제목을 입력하세요"),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: "내용을 입력하세요"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    "title": titleController.text,
                    "content": contentController.text
                  });
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );

      if (result != null) {
        // ImageProviderClass를 사용하여 이미지 추가
        Provider.of<ImageProviderClass>(context, listen: false).addImage({
          "image": bytes,
          "title": result["title"]!,
          "content": result["content"]!
        });
      }
    }
  }

  void _showImageContent(Map<String, dynamic> imageData) {
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
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        imageData["title"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(imageData["content"]),
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
    // 이미지를 공유하는 위젯
    final images = Provider.of<ImageProviderClass>(context).images;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getLanguage(message: "나의 보관함")),
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: _pickImageAndComment,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imageData = images[index];
            return GestureDetector(
              onTap: () => _showImageContent(imageData),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(
                      imageData["image"],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Text(
                          imageData["title"],
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
