class LoginRequest {
  LoginRequest({
      this.username, 
      this.password,});
//Map Json to Dart
  LoginRequest.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
  }
  //variable
  String? username;
  String? password;
  //Request Body Json, dart to json
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    return map;
  }

}