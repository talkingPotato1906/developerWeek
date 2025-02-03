import 'package:dv/gallery/image_provider.dart';
import 'package:dv/gallery/swipe_page_view.dart';
import 'package:dv/login/login_provider.dart'; // 로그인 상태 확인을 위한 import 추가
import 'package:dv/login/login_required_page.dart'; // 로그인 필요 페이지 추가
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LogInProvider>(context);

    // ✅ 로그인하지 않은 경우 LoginRequiredPage로 이동
    if (!loginProvider.isLoggedIn) {
      return LoginRequiredPage();
    }

    return PhotoPageContent(); // ✅ 로그인한 경우 기존 페이지 표시
  }
}

class PhotoPageContent extends StatefulWidget {
  const PhotoPageContent({super.key});

  @override
  _PhotoPageContentState createState() => _PhotoPageContentState();
}

class _PhotoPageContentState extends State<PhotoPageContent> {
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
          final languageProvider = Provider.of<LanguageProvider>(context);
          final themeProvider = Provider.of<ThemeProvider>(context);
          return AlertDialog(
            title: Text(languageProvider.getLanguage(message: "제목과 내용 입력"),
                style: themeProvider.getTheme().textTheme.titleMedium),
            backgroundColor:
                ColorPalette.palette[themeProvider.selectedThemeIndex][0],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: languageProvider.getLanguage(
                        message: "제목을 입력하세요",
                      ),
                      hintStyle: TextStyle(
                        color: ColorPalette
                            .palette[themeProvider.selectedThemeIndex][2],
                      ),
                      fillColor:
                          themeProvider.getTheme().textTheme.bodyMedium?.color,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                  [2])),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                  [3]))),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                      hintText:
                          languageProvider.getLanguage(message: "내용을 입력하세요"),
                      hintStyle: TextStyle(
                        color: ColorPalette
                            .palette[themeProvider.selectedThemeIndex][2],
                      ),
                      fillColor:
                          themeProvider.getTheme().textTheme.bodyMedium?.color,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                  [2])),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                  [3]))),
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
                child: Text(
                  languageProvider.getLanguage(message: "확인"),
                  style: themeProvider.getTheme().textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      );

      if (result != null) {
        Provider.of<ImageProviderClass>(context, listen: false).addImage({
          "image": bytes,
          "title": result["title"]!,
          "content": result["content"]!
        });
      }
    }
  }

  void _showImageContent(BuildContext context, int index) {
    final provider = Provider.of<ImageProviderClass>(context, listen: false);
    final imageData = provider.images[index];
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ImageProviderClass>(
          builder: (context, provider, child) {
            bool isSelected = provider.selectedImages.contains(imageData);

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
                                SizedBox(height: 16),
                                Text(
                                  imageData["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                SizedBox(height: 16),
                                Text(imageData["content"]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (!isSelected &&
                                  provider.selectedImages.length >= 9) {
                                _showMaxSelectionWarning(context);
                              } else {
                                provider.toggleGalleryImage(imageData);
                              }
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    if (!isSelected &&
                                        provider.selectedImages.length >= 9) {
                                      _showMaxSelectionWarning(context);
                                    } else {
                                      provider.toggleGalleryImage(imageData);
                                    }
                                  },
                                  side: BorderSide(
                                      color: ColorPalette.palette[
                                          themeProvider.selectedThemeIndex][2]),
                                  activeColor: ColorPalette.palette[
                                      themeProvider.selectedThemeIndex][2],
                                  checkColor: ColorPalette.palette[
                                      themeProvider.selectedThemeIndex][0],
                                ),
                                Text(
                                    languageProvider.getLanguage(
                                        message: "갤러리에 추가"),
                                    style: TextStyle(
                                        color: ColorPalette.palette[
                                            themeProvider
                                                .selectedThemeIndex][2],
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _editImageContent(context, index);
                              },
                              icon: Icon(Icons.edit,
                                  color: ColorPalette.palette[
                                      themeProvider.selectedThemeIndex][0]),
                              label: Text(
                                  languageProvider.getLanguage(message: "수정"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.palette[themeProvider
                                          .selectedThemeIndex][0])),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.palette[
                                    themeProvider.selectedThemeIndex][1],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                provider.removeImage(index);
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.delete,
                                  color: ColorPalette.palette[
                                      themeProvider.selectedThemeIndex][0]),
                              label: Text(
                                languageProvider.getLanguage(message: "삭제"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.palette[
                                        themeProvider.selectedThemeIndex][0]),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.palette[
                                    themeProvider.selectedThemeIndex][2],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editImageContent(BuildContext context, int index) {
    final provider = Provider.of<ImageProviderClass>(context, listen: false);
    final imageData = provider.images[index];
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    TextEditingController titleController =
        TextEditingController(text: imageData["title"]);
    TextEditingController contentController =
        TextEditingController(text: imageData["content"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(languageProvider.getLanguage(message: "제목과 내용 수정"),
              style: themeProvider.getTheme().textTheme.titleMedium),
          backgroundColor:
              ColorPalette.palette[themeProvider.selectedThemeIndex][0],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText:
                        languageProvider.getLanguage(message: "제목을 입력하세요"),
                    hintStyle: TextStyle(
                      color: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][2],
                    ),
                    fillColor:
                        themeProvider.getTheme().textTheme.bodyMedium?.color,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette
                                .palette[themeProvider.selectedThemeIndex][2])),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette
                                    .palette[themeProvider.selectedThemeIndex]
                                [3]))),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                    hintText:
                        languageProvider.getLanguage(message: "내용을 입력하세요"),
                    hintStyle: TextStyle(
                      color: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][2],
                    ),
                    fillColor:
                        themeProvider.getTheme().textTheme.bodyMedium?.color,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette
                                .palette[themeProvider.selectedThemeIndex][2])),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette
                                    .palette[themeProvider.selectedThemeIndex]
                                [3]))),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                provider.updateImage(
                    index, titleController.text, contentController.text);
                Navigator.of(context).pop(); // ✅ 다이얼로그 닫기

                // ✅ UI를 먼저 갱신한 후 다이얼로그 다시 열기
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showImageContent(context, index);
                });
              },
              child: Text(
                languageProvider.getLanguage(message: "확인"),
                style: themeProvider.getTheme().textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMaxSelectionWarning(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              ColorPalette.palette[themeProvider.selectedThemeIndex][0],
          title: Text(languageProvider.getLanguage(message: "갤러리 선택 제한"),
              style: TextStyle(
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                      [3])),
          content: Text(
              languageProvider.getLanguage(message: "최대 9개의 전시품만 선택할 수 있습니다."),
              style: TextStyle(
                  color: ColorPalette.palette[themeProvider.selectedThemeIndex]
                      [3])),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(languageProvider.getLanguage(message: "확인"),
                  style: TextStyle(
                      color: ColorPalette
                          .palette[themeProvider.selectedThemeIndex][3])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageProviderClass>(context);
    final images = provider.images;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(languageProvider.getLanguage(message: "나의 보관함")),
        actions: [
          IconButton(
            // ✅ 보기 모드 변경 버튼 추가
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SwipePageView()), // ✅ 새로운 뷰로 이동
              );
            },
          ),
        ],
      ), // ✅ 상단 이미지 추가 버튼 삭제

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
            bool isSelected = provider.selectedImages.contains(imageData);
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);

            return GestureDetector(
              onTap: () => _showImageContent(context, index),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.memory(
                      imageData["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      //갤러리에 추가 시 체크버튼(왼쪽아래래)
                      bottom: 8,
                      left: 8,
                      child: Icon(Icons.check_circle,
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][2]),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      // ✅ 하단 FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageAndComment,
        child: Icon(Icons.add),
      ),
    );
  }
}
