import 'package:dv/sign_up/account_list.dart';
import 'package:flutter/material.dart';

class NicknameProvider extends ChangeNotifier{
  String _nickname = AccountList.userInformation.keys.first;

  String get nickname => _nickname;

  void changeNickname (String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  String getNickname() {
    return _nickname;
  }
}