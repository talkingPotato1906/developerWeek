import 'package:dv/sign_up/account_list.dart';

Map<String, bool> signUpRules(String email, String password) {

  bool appropriateEmail(email) {
  if (email.contains("@")){
    return true;

  } else {
    return false;
  }
}

bool alreadyInEmail(email) {
  if (AccountList.userInformation.containsKey(email)) {
    return true;
  } else {
    return false;
  }
}

bool appropriatePassword(password) {
  if (password.length >= 8 && password.length <= 20) {
    bool hasAlphabet = RegExp(r'[a-zA-Z]').hasMatch(password);
    bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    bool hasSpecialChar = RegExp(r'[!@#%^&*]').hasMatch(password);

    return hasAlphabet && hasDigit && hasSpecialChar;
  } else {
    return false;
  }
}

  if (!appropriateEmail(email)) {
    return {"부적합한 이메일입니다.": false};
  }
  else if (alreadyInEmail(email)) {
    return {"이미 존재하는 계정입니다.": false};
  }
  else if (!appropriatePassword(password)) {
    return {"비밀번호는 8자 이상 20자 이하, 영문자와 숫자 및 특수문자(!@#%^&*)를 포함해야 합니다." : false};
  }
  else {
    return {"회원가입에 성공했습니다.": true};
  }
}

