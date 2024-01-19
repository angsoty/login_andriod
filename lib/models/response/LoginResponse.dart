class LoginResponse {
  LoginResponse({
      this.id, 
      this.username, 
      this.email, 
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.image, 
      this.token,});

  LoginResponse.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    image = json['image'];
    token = json['token'];
  }
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['image'] = image;
    map['token'] = token;
    return map;
  }

  @override
  String toString() {
    return 'LoginResponse{id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, gender: $gender, image: $image, token: $token}';
  }
}