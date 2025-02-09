import 'package:dv/firebase_login/get_user_data.dart';
import 'package:dv/menu/menu.dart';
import 'package:dv/mypage/my_page_edit.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/setting_screen.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late LanguageProvider languageProvider;
  late GetUserData getUserData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    getUserData = Provider.of<GetUserData>(context, listen: false);
    getUserData.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 8;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Consumer<GetUserData>(builder: (context, getUserData, child) {
      if (getUserData.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      String nickname = getUserData.userData["nickname"];
      int point = getUserData.userData["points"];
      List<dynamic> profiles = getUserData.userData["profile"];


      return Scaffold(
        appBar: AppBar(
          title: Text(languageProvider.getLanguage(message: "마이 페이지")),
        ),
        floatingActionButton: FloatingMenuButton(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: double.infinity, // 최대한 화면 크기에 맞게 설정
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 프로필 아이콘 및 버튼
                      Column(
                        children: [
                          profiles.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    profiles[0],
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.account_circle,
                                        size: imageSize,
                                        color: ColorPalette.palette[
                                                themeProvider
                                                    .selectedThemeIndex][3]
                                            .withAlpha(128),
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: imageSize,

                                  color: ColorPalette
                                      .palette[themeProvider.selectedThemeIndex]
                                          [3]
                                      .withAlpha(128),
                                ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              showEditProfile(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette
                                  .palette[themeProvider.selectedThemeIndex][3],
                            ),
                            child: Text(
                              languageProvider.getLanguage(message: "프로필 편집"),
                              style: TextStyle(
                                color: ColorPalette.palette[
                                    themeProvider.selectedThemeIndex][0],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // 닉네임 및 포인트 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                Text(
                                  languageProvider.getLanguage(
                                      message: "보유 포인트"),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.palette[
                                        themeProvider.selectedThemeIndex][2],
                                  ),
                                ),
                                Text(
                                  " : $point pt",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.palette[
                                        themeProvider.selectedThemeIndex][2],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 설정 아이콘 버튼
                      IconButton(
                        //  settings/setting_screen.dart에서 뒤로가기 누르면 감지하고 변경 내용 반영
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingScreen(),
                              ));

                          if (result == true) {
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          Icons.settings,
                          color: ColorPalette
                              .palette[themeProvider.selectedThemeIndex][2],
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
