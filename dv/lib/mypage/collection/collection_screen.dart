import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/settings/theme/color_palette.dart';
import 'package:dv/settings/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<String> trophies = [];
  List<String> profiles = [];
  List<String> purchasedItems = []; // purchasedItems 변수 추가

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserCollections();
  }

  Future<void> fetchUserCollections() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          trophies = List<String>.from(data['trophy'] ?? []);
          profiles = List<String>.from(data['profile'] ?? []);
          purchasedItems = List<String>.from(
              data['purchasedItems'] ?? []); // purchasedItems 필드 추가
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching collections: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Trophies",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        trophies.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 한 줄에 4개 표시 (칸 크기 조정)
                  crossAxisSpacing: 4, // 칸 사이 간격 줄이기
                  mainAxisSpacing: 4, // 상하 간격 줄이기
                  childAspectRatio: 1, // 정사각형 칸 비율 유지
                ),
                itemCount: trophies.length, // Firebase에서 가져온 trophies 리스트
                itemBuilder: (context, index) {
                  final trophyUrl = trophies[index]; // Firebase에서 가져온 URL

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // 배경색 투명
                      border: Border.all(
                          color: Colors.grey.shade300, width: 1), // 선택적 테두리
                      borderRadius: BorderRadius.circular(10), // 모서리 둥글게 처리
                    ),
                    child: Image.network(
                      trophyUrl, // Firebase의 URL로 이미지 표시
                      fit: BoxFit.contain, // 이미지 비율 유지하며 컨테이너에 맞춤
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error,
                            color: Colors.red); // 이미지 로드 실패 시
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child; // 로딩 완료
                        return Center(
                            child: CircularProgressIndicator()); // 로딩 중
                      },
                    ),
                  );
                },
              )
            : Center(child: Text("No trophies yet")),
        // 구분선 추가
        Divider(color: ColorPalette.palette[themeProvider.selectedThemeIndex][4],),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Profiles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        purchasedItems.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 한 줄에 표시할 이미지 개수
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 8,
                ),
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  final itemName = purchasedItems[index];
                  final imagePath =
                      "assets/profile/$itemName.png"; // 로컬 이미지 경로 생성

                  // 화면 크기 계산
                  final screenWidth = MediaQuery.of(context).size.width;
                  final imageSize = (screenWidth / 8) - 30; // 이미지 크기 계산 (간격 포함)

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: imageSize, // 동적 너비
                        height: imageSize, // 동적 높이
                        child: CircleAvatar(
                          backgroundImage: AssetImage(imagePath),
                          backgroundColor:
                              Colors.grey.shade200, // 에러 시 기본 배경색 설정
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Error loading image: $imagePath');
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : Center(child: Text("No purchased items yet")),
      ],
    );
  }
}
