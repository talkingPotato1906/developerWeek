import 'package:dv/firebase_login/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showEditProfile(BuildContext context) {  //  profile DB 구축되면 int index 추가
  final getUserData = Provider.of<GetUserData>(context, listen: false);
  final List<dynamic> profiles = getUserData.userData["profile"];
  final String nickname = getUserData.userData["nickname"];

  TextEditingController nicknameController = TextEditingController(text: nickname);

  bool isEditing = false;

  showDialog(context: context, builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Row(children: [
          CircleAvatar(radius: 30,
          child: profiles.isEmpty
          ? Icon(Icons.person)
          : Image.asset(profiles[0]),
          ),
          const SizedBox(width: 16,),
          Expanded(child: GestureDetector(
            onTap: () {
              setState(() {
                isEditing = true;
              },);
            },
            child: isEditing
            ? TextFormField(
              controller: nicknameController,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty && value != nickname) {
                  getUserData.updateNickname(value);
                }
                setState(() {
                  isEditing = false;
                },);
              },
            )
            : Row(children: [
              Expanded(child: Text(nickname,
              style: TextStyle(fontSize: 18))),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  },);
                },
                child: Icon(Icons.edit, size: 18,),
              )
            ],)
          ),)
        ],),
      );
    },);
  },);
}