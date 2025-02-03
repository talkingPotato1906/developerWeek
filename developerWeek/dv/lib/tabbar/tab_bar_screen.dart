import 'package:dv/mypage/my_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 4, vsync: this);

  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.edit,
    Icons.person
  ];

  late IconData selectedTab;

  @override
  void initState() {
    super.initState();
    selectedTab = iconList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: List.generate(iconList.length, (index) {
          return Center(child: Icon(iconList[index], size: 100)); // 각 탭에 해당하는 화면 표시
        }),
      ),

      bottomNavigationBar: TabBar(
        controller: tabController,
        onTap: (value) {
          if (iconList[value] == Icons.person) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const MyPageScreen();  // MyPageScreen으로 이동
                },
              ),
            );
          } else {
            setState(() {
              selectedTab = iconList[value];  // 선택된 탭 아이콘 업데이트
            });
          }
        },
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey.shade100,
        ),
        tabs: List.generate(iconList.length, (index) {
          return Tab(icon: Icon(iconList[index])); //탭에 아이콘 설정
        }),
      ),
    );
  }
}
