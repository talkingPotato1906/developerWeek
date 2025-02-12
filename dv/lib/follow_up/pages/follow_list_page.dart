import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';
import '../widgets/follow_list_item.dart';

import 'package:dv/settings/language/language_provider.dart';


class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider=Provider.of<LanguageProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Consumer<FollowProvider>(
          // ✅ Consumer로 감싸기
          builder: (context, provider, child) {
            if (provider.following.isEmpty) {
              return Text(languageProvider.getLanguage(message: "팔로우한 사람이 없습니다."),);
            }
      
            return Column(
              children: [
                
                Text("팔로잉",),
                SizedBox(height: 10,),
                ListView.builder(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
