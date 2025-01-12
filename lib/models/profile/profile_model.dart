class UserProfile {
  final int? id;
  final String? fName;
  final String? lName;
  final String? email;
  final String? phone;
  final String? image;
  final int? wallet;
  final int? status;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final int? points;
  final List<dynamic>? address;
  final String? bio;
  final String? code;
  final String? role;
  final String? imageLink;
  final String? name;
  final String? type;

  UserProfile({
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
    this.address,
    this.bio,
    this.code,
    this.role,
    this.imageLink,
    this.name,
    this.type,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
      address: json['address'] != null ? List<dynamic>.from(json['address']) : null,
      bio: json['bio'],
      code: json['code'],
      role: json['role'],
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
      'address': address,
      'bio': bio,
      'code': code,
      'role': role,
      'image_link': imageLink,
      'name': name,
      'type': type,
    };
  }
}
