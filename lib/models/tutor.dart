class Tutor {
  String? id;
  String? email;
  String? phone;
  String? name;
  String? password;
  String? description;
  String? dateReg;

  Tutor(
      {this.id,
      this.email,
      this.phone,
      this.name,
      this.password,
      this.description,
      this.dateReg});

  Tutor.fromJson(Map<String, dynamic> json) {
    id = json['tutor_id'];
    email = json['tutor_email'];
    phone = json['tutor_phone'];
    name = json['tutor_name'];
    password = json['tutor_password'];
    description = json['tutor_description'];
    dateReg = json['tutor_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['name'] = name;
    data['password'] = password;
    data['description'] = description;
    data['dateReg'] = dateReg;
    return data;
  }
}
