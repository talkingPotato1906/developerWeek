import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dv/firebase_login/get_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSelectionDialog extends StatefulWidget {
  const ProfileSelectionDialog({super.key});

  @override
  _ProfileSelectionDialogState createState() => _ProfileSelectionDialogState();
}

class _ProfileSelectionDialogState extends State<ProfileSelectionDialog> {
  final List<String> allProfiles = [
    "assets/profile/dog.png",
    "assets/profile/dog2.png",
    "assets/profile/snake.png",
    "assets/profile/snake2.png",
    "assets/profile/owl.png",
    "assets/profile/owl2.png",
    "assets/profile/deer.png",
    "assets/profile/deer2.png",
  ];

  List<String> purchasedProfiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPurchasedProfiles();
  }

  Future<void> loadPurchasedProfiles() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final purchasedItems = List<String>.from(userDoc['purchasedItems'] ?? []);

      setState(() {
        purchasedProfiles = purchasedItems
            .map((itemName) => "assets/profile/$itemName.png")
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Firestore에서 구매한 프로필 데이터 가져오기 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔹 **프로필 변경 후 즉시 마이페이지 갱신 & 다이얼로그 전체 닫기**
  Future<void> updateProfile(String selectedProfile) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "profile": [selectedProfile],
    });

    print("✅ 프로필 이미지 업데이트: $selectedProfile");

    // 🔥 마이페이지 데이터 즉시 갱신
    Provider.of<GetUserData>(context, listen: false).getUserData();

    // 🔥 모든 다이얼로그 닫기 (프로필 선택 & 프로필 편집)
    Navigator.of(context, rootNavigator: true).pop(); // 프로필 편집 다이얼로그 닫기
    Navigator.pop(context); // 프로필 선택 다이얼로그 닫기
  }

  void showPurchaseRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("구매 필요"),
          content: const Text("이 프로필을 사용하려면 먼저 포인트샵에서 구매해야 합니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: isLoading
          ? const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "프로필 선택",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: allProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = allProfiles[index];
                      final isPurchased = purchasedProfiles.contains(profile);

                      return GestureDetector(
                        onTap: () {
                          if (isPurchased) {
                            updateProfile(profile);
                          } else {
                            showPurchaseRequiredDialog();
                          }
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isPurchased
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  profile,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (!isPurchased)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.block,
                                        color: Colors.red, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      "구매 필요",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

/// 📌 프로필 선택 다이얼로그 호출 함수
Future<void> showProfileSelection(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const ProfileSelectionDialog();
    },
  );
}
