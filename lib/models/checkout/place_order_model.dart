class OrderTypesAndPayments {
  final List<OrderType> orderTypes;
  final List<PaymentMethod> paymentMethods;
  final List<Branch> branches;

  OrderTypesAndPayments({
    required this.orderTypes,
    required this.paymentMethods,
    required this.branches,
  });

  factory OrderTypesAndPayments.fromJson(Map<String, dynamic> json) {
    return OrderTypesAndPayments(
      orderTypes: (json['order_types'] as List)
          .map((item) => OrderType.fromJson(item))
          .toList(),
      paymentMethods: (json['payment_methods'] as List)
          .map((item) => PaymentMethod.fromJson(item))
          .toList(),
      branches: (json['branches'] as List)
          .map((item) => Branch.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_types': orderTypes.map((item) => item.toJson()).toList(),
      'payment_methods': paymentMethods.map((item) => item.toJson()).toList(),
      'branches': branches.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderType {
  final String type;
  final int status;

  OrderType({
    required this.type,
    required this.status,
  });

  factory OrderType.fromJson(Map<String, dynamic> json) {
    return OrderType(
      type: json['type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
    };
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final String? description;
  final String? logo;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  PaymentMethod({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Branch {
  final int id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String? image;
  final String? coverImage;
  final String foodPreparationTime;
  final double latitude;
  final String longitude;
  final String coverage;
  final int status;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String role;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    this.image,
    this.coverImage,
    required this.foodPreparationTime,
    required this.latitude,
    required this.longitude,
    required this.coverage,
    required this.status,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.role,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      coverImage: json['cover_image'],
      foodPreparationTime: json['food_preparion_time'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: json['longitude'],
      coverage: json['coverage'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'image': image,
      'cover_image': coverImage,
      'food_preparion_time': foodPreparationTime,
      'latitude': latitude,
      'longitude': longitude,
      'coverage': coverage,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role': role,
    };
  }
}
