import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/category/category_post_screen.dart';
import 'package:dv/firebase_login/get_user_data.dart';
import 'package:dv/menu/menu.dart';
import 'package:dv/settings/language/language_provider.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final String initialCategory; // 기본 선택된 카테고리

  const CategoryScreen({super.key, required this.initialCategory});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String selectedCategory;
  TextEditingController searchController =
      TextEditingController(); // 검색어 입력을 위한 컨트롤러
  String searchQuery = ""; // 검색어 저장
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> userData = {};
  bool isLoading = true;
 

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory; // 기본 선택 카테고리 설정
    fetchData();
  }

  // 카테고리 목록
  final List<String> categories = ["식물", "식기", "원석", "주류", "책", "피규어"];

  Future<void> fetchData() async {
    await fetchPosts();
    await fetchUser();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 데이터 불러오기
  Future<void> fetchPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where("category", isEqualTo: selectedCategory)
        .orderBy("createdAt", descending: true)
        .get();

    setState(() {
      posts = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "title": doc["title"],
          "uid": doc["uid"],
          "createdAt": doc["createdAt"],
          "imageUrl": doc["imageUrl"],
          "content": doc["content"],
          "category": doc["category"],
          "reactions": doc["reactions"]
        };
      }).toList();
    });
  }

  Future<void> fetchUser() async {
    final getUserData = Provider.of<GetUserData>(context, listen: false);
    
    if (mounted) {
    setState(() {
      userData = Map<String, dynamic>.from(getUserData.userData);
    });
    }
  }

  // 검색어를 기준으로 필터링된 게시글 목록 반환
  List<Map<String, dynamic>> getFilteredPosts() {
    return posts
        .where(
          (post) => post["title"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  //  날짜 포맷 함수
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider=Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
     
     List<dynamic> profiles = List<dynamic>.from(userData["profile"] ?? []);
     int profileIndex = userData["profileIdx"] ?? 0;
     String nickname = userData["nickname"] ?? "";

    return isLoading?
    Scaffold(
      body: Center(child: CircularProgressIndicator())
    )

    : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languageProvider.getLanguage(message: selectedCategory),)//Text(selectedCategory),
      ),
      floatingActionButton: FloatingMenuButton(),
      body: Row(
        children: [
          // 왼쪽 사이드바 (카테고리 버튼)
          Container(
            width: 150,
            padding: EdgeInsets.all(12),
            color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30,
                child: ClipOval(
                  child: 
                  profiles.isEmpty ?
                  Icon(Icons.person):
                  Image.network(profiles[profileIndex]),
                )),
                SizedBox(height: 10),
                Text(nickname, style: TextStyle(fontWeight: FontWeight.bold, color: ColorPalette.palette[themeProvider.selectedThemeIndex][1])),
                SizedBox(height: 20),
                Text(
                   languageProvider.getLanguage(message: "▼ 카테고리"),
                  style: TextStyle(fontWeight: FontWeight.bold, color: ColorPalette.palette[themeProvider.selectedThemeIndex][1])
                  ),
                // 카테고리 버튼 리스트
                ...categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        searchQuery = ""; // 카테고리를 변경할 때 검색어 초기화
                        searchController.clear();
                      });
                      fetchPosts();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? ColorPalette.palette[themeProvider.selectedThemeIndex][1]
                            : ColorPalette.palette[themeProvider.selectedThemeIndex][4],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Center(
                        child: Text(
                          languageProvider.getLanguage(message: category),
                          style: TextStyle(
                            color: selectedCategory == category
                                ? ColorPalette.palette[themeProvider.selectedThemeIndex][4]
                                : ColorPalette.palette[themeProvider.selectedThemeIndex][1],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // 메인 콘텐츠
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 검색창
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: languageProvider.getLanguage(message: "검색"),
                            hintStyle: TextStyle(color: ColorPalette.palette[themeProvider.selectedThemeIndex][3]),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorPalette.palette[themeProvider.selectedThemeIndex][4]
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorPalette.palette[themeProvider.selectedThemeIndex][2]
                              )
                            ),

                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],),
                              onPressed: () {
                                setState(() {
                                  searchQuery = "";
                                  searchController.clear();
                                });
                              },
                            ),
                          ),
                          onChanged: (query) {
                            setState(() {
                              searchQuery = query;
                            });
                          },
                          style: TextStyle(color: ColorPalette.palette[themeProvider.selectedThemeIndex][2]),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.search, color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],), onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 20),

                  // 게시글 리스트 (정렬 포함)
                  Expanded(
                    child: Column(
                      children: [
                        // 헤더
                        Container(
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                         ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageProvider.getLanguage(message: "제목"),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text(
                                    languageProvider.getLanguage(message: "날짜"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 45,),
                                  Icon(Icons.arrow_drop_down, color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(color: ColorPalette.palette[themeProvider.selectedThemeIndex][4],),

                        // 게시글 리스트 (검색 필터링 적용)
                        Expanded(
                            child: posts.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    itemCount: getFilteredPosts().length,
                                    itemBuilder: (context, index) {
                                      var post = getFilteredPosts()[index];
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                // Navigator.push로 화면 이동
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CategoryPostScreen(
                                                      postId:
                                                          post["id"], // 문서 ID
                                                      title: post[
                                                          "title"], // 게시글 제목
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  Text(post["title"],
                                                  style: TextStyle(color: ColorPalette.palette[themeProvider.selectedThemeIndex][3],), // 제목 표시
                                            ),
                                            ),
                                            Text(formatTimestamp(post["createdAt"]))
                                            
                                          ],
                                        ),
                                      );
                                    },
                                  )),

                        // 페이지네이션
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: () {}, child: Text("1")),
                            TextButton(onPressed: () {}, child: Text("2")),
                            TextButton(onPressed: () {}, child: Text("3")),
                            TextButton(onPressed: () {}, child: Text("4")),
                            TextButton(onPressed: () {}, child: Text("5")),
                            TextButton(onPressed: () {}, child: Text("다음")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
