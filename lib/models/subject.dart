class Subject {
  String? id;
  String? name;
  String? description;
  String? price;
  String? tutorId;
  String? sessionsNumber;
  String? rating;

  Subject(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.tutorId,
      this.sessionsNumber,
      this.rating});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['subject_id'];
    name = json['subject_name'];
    description = json['subject_description'];
    price = json['subject_price'];
    tutorId = json['tutor_id'];
    sessionsNumber = json['subject_sessions'];
    rating = json['subject_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['tutorId'] = tutorId;
    data['sessionsNumber'] = sessionsNumber;
    data['rating'] = rating;
    return data;
  }
}
