import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory; // 기본 선택 카테고리 설정
    fetchPosts();
  }

  // 카테고리 목록
  final List<String> categories = ["식물", "식기", "원석", "주류", "책", "피규어"];

  // 더미 게시글 데이터
  Future<void> fetchPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where("category", isEqualTo: selectedCategory)
        .orderBy("createdAt", descending: true)
        .get();

        setState(() {
          posts = querySnapshot.docs.map((doc) {
            return {
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

  // 검색어를 기준으로 필터링된 게시글 목록 반환
  List<Map<String, dynamic>> getFilteredPosts() {
    return posts.where((post) => post["title"].toString().toLowerCase().contains(searchQuery.toLowerCase()),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(selectedCategory),
      ),
      body: Row(
        children: [
          // 왼쪽 사이드바 (카테고리 버튼)
          Container(
            width: 150,
            padding: EdgeInsets.all(12),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(height: 10),
                Text("nickname", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("▼ 카테고리", style: TextStyle(fontWeight: FontWeight.bold)),
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
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
                            hintText: "검색...",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
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
                        ),
                      ),
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 20),

                  // 게시글 리스트 (정렬 포함)
                  Expanded(
                    child: Column(
                      children: [
                        // 헤더
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("제목",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text("날짜",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),

                        // 게시글 리스트 (검색 필터링 적용)
                        Expanded(
                          child: posts.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: getFilteredPosts().length,
                            itemBuilder: (context, index) {
                              var post = getFilteredPosts()[index];
                              return Padding(padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(post["title"]),
                                  Text(post["createdAt"].toString())
                                ],),);
                            },)
                        ),

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
