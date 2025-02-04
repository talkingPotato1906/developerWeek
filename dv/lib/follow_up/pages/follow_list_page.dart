import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';
import '../widgets/follow_list_item.dart';

class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내가 팔로우하는 사람들")),
      body: Consumer<FollowProvider>(
        // ✅ Consumer로 감싸기
        builder: (context, provider, child) {
          if (provider.following.isEmpty) {
            return Center(child: Text("팔로우한 사람이 없습니다."));
          }

          return ListView.builder(
            itemCount: provider.following.length,
            itemBuilder: (context, index) {
              final user = provider.following[index];
              return FollowListItem(
                name: user["name"]!,
                profileImage: user["profileImage"]!,
              );
            },
          );
        },
      ),
    );
  }
}
