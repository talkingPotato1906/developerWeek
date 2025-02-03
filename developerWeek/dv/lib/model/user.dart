class User {
  String name;
  String email;
  String password;

  User(this.name, this.email, this.password);

  //메모: 이거 int 형은 문자열 전환해야 해서
  //'user_id' : user_id.toString(), 형태로 해야 함
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
