//개별 사용자 UI
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';

class FollowListItem extends StatelessWidget {
  final String name;
  final String profileImage;

  const FollowListItem(
      {super.key, required this.name, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(name),
      trailing: ElevatedButton(
        onPressed: () {
          Provider.of<FollowProvider>(context, listen: false).unfollow(name);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text("언팔로우", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
