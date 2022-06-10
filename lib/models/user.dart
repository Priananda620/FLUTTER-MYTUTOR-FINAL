class User {
  String? id;
  String? email;
  String? username;
  String? phone;
  String? address;
  String? userImage;

  User(
      {this.id,
      this.email,
      this.username,
      this.phone,
      this.address,
      this.userImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['userID'];
    email = json['user_email'];
    username = json['username'];
    phone = json['user_phone'];
    address = json['user_address'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['address'] = address;
    data['user_image'] = userImage;
    return data;
  }

  String? getUsername() {
    return username;
  }
}
