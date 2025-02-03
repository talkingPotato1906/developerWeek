//api.dart: api와 php 연결 파일

class API {
  static const hostConnect = "http://192.168.80.1/api_new_members";
  static const hostConnectUser = "$hostConnect/user/signup.php";
  static const validateEmail = "$hostConnect/user/validate_email.php";
}
