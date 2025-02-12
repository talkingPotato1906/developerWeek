import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';
import '../widgets/follow_list_item.dart';

class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Consumer<FollowProvider>(
        // ✅ Consumer로 감싸기
        builder: (context, provider, child) {
          if (provider.following.isEmpty) {
            return Text("팔로우한 사람이 없습니다.");
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: provider.following.length,
            itemBuilder: (context, index) {
              final user = provider.following[index];

              if (user.isEmpty || !user.containsKey("uid")) {
                return SizedBox.shrink();
              }

              return FollowListItem(
                uid: user["uid"]!,
              );
            },
          );
        },
      ),
    );
  }
}
