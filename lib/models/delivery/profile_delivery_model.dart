class DeliveryUser {
  final int id;
  final String firstName;
  final String lastName;
  final String identityType;
  final String identityNumber;
  final String email;
  final String phone;
  final String? image;
  final String? identityImage;
  final int? branchId;
  final int status;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final int orders;
  final String role;
  final String imageLink;

  DeliveryUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.identityType,
    required this.identityNumber,
    required this.email,
    required this.phone,
    this.image,
    this.identityImage,
    this.branchId,
    required this.status,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.orders,
    required this.role,
    required this.imageLink,
  });

  // Factory constructor to create an instance from JSON
  factory DeliveryUser.fromJson(Map<String, dynamic> json) {
    return DeliveryUser(
      id: json['id'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      identityType: json['identity_type'],
      identityNumber: json['identity_number'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      identityImage: json['identity_image'],
      branchId: json['branch_id'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orders: json['orders'],
      role: json['role'],
      imageLink: json['image_link'],
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': firstName,
      'l_name': lastName,
      'identity_type': identityType,
      'identity_number': identityNumber,
      'email': email,
      'phone': phone,
      'image': image,
      'identity_image': identityImage,
      'branch_id': branchId,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'orders': orders,
      'role': role,
      'image_link': imageLink,
    };
  }
}
