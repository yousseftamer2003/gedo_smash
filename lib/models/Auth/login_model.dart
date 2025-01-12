class LoginModel {
  User? user;
  String? token;

  LoginModel({
    this.user,
    this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
    };
  }
}

class User {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? image;
  int? wallet;
  int? status;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? points;
  String? bio;
  String? code;
  String? role;
  String? token;
  String? imageLink;
  String? name;
  String? type;

  User({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.image,
    this.wallet,
    this.status,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.points,
    this.bio,
    this.code,
    this.role,
    this.token,
    this.imageLink,
    this.name,
    this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      wallet: json['wallet'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      points: json['points'],
      bio: json['bio'],
      code: json['code'],
      role: json['role'],
      token: json['token'],
      imageLink: json['image_link'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'image': image,
      'wallet': wallet,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'points': points,
      'bio': bio,
      'code': code,
      'role': role,
      'token': token,
      'image_link': imageLink,
      'name': name,
      'type': type,
    };
  }
}
