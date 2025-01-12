class OrderHistory {
  List<Order> orders;

  OrderHistory({required this.orders});

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': List<dynamic>.from(orders.map((x) => x.toJson())),
    };
  }
}

class Order {
  int id;
  String date;
  int userId;
  dynamic branchId;
  double amount;
  String orderStatus;
  String orderType;
  String? paymentStatus;
  double totalTax;
  double totalDiscount;
  String paidBy;
  dynamic createdAt;
  String updatedAt;
  int pos;
  int deliveryId;
  int? addressId;
  dynamic notes;
  double couponDiscount;
  Address? address;

  Order({
    required this.id,
    required this.date,
    required this.userId,
    this.branchId,
    required this.amount,
    required this.orderStatus,
    required this.orderType,
    this.paymentStatus,
    required this.totalTax,
    required this.totalDiscount,
    required this.paidBy,
    this.createdAt,
    required this.updatedAt,
    required this.pos,
    required this.deliveryId,
    this.addressId,
    this.notes,
    required this.couponDiscount,
    this.address,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      userId: json['user_id'] ?? 0,
      branchId: json['branch_id'], // dynamic already handles null
      amount: (json['amount'] ?? 0).toDouble(),
      orderStatus: json['order_status'] ?? 'Unknown',
      orderType: json['order_type'] ?? 'Unknown',
      paymentStatus: json['payment_status'], // String? for nullable
      totalTax: (json['total_tax'] ?? 0).toDouble(),
      totalDiscount: (json['total_discount'] ?? 0).toDouble(),
      paidBy: json['paid_by'] ?? 'Unknown',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? '',
      pos: json['pos'] ?? 0,
      deliveryId: json['delivery_id'] ?? 0,
      addressId: json['address_id'], // int? for nullable
      notes: json['notes'], // dynamic to handle any type
      couponDiscount: (json['coupon_discount'] ?? 0).toDouble(),
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'user_id': userId,
      'branch_id': branchId,
      'amount': amount,
      'order_status': orderStatus,
      'order_type': orderType,
      'payment_status': paymentStatus,
      'total_tax': totalTax,
      'total_discount': totalDiscount,
      'paid_by': paidBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pos': pos,
      'delivery_id': deliveryId,
      'address_id': addressId,
      'notes': notes,
      'coupon_discount': couponDiscount,
      'address': address?.toJson(),
    };
  }
}

class Address {
  int id;
  int zoneId;
  String address;
  String street;
  String buildingNum;
  String floorNum;
  String? apartment;
  String? additionalData;
  String type;
  dynamic createdAt;
  dynamic updatedAt;
  Zone zone;

  Address({
    required this.id,
    required this.zoneId,
    required this.address,
    required this.street,
    required this.buildingNum,
    required this.floorNum,
    this.apartment,
    this.additionalData,
    required this.type,
    this.createdAt,
    this.updatedAt,
    required this.zone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      zoneId: json['zone_id'] ?? 0,
      address: json['address'] ?? '',
      street: json['street'] ?? '',
      buildingNum: json['building_num'] ?? '',
      floorNum: json['floor_num'] ?? '',
      apartment: json['apartment'], // String? for nullable
      additionalData: json['additional_data'], // String? for nullable
      type: json['type'] ?? 'Unknown',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      zone: Zone.fromJson(json['zone']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zone_id': zoneId,
      'address': address,
      'street': street,
      'building_num': buildingNum,
      'floor_num': floorNum,
      'apartment': apartment,
      'additional_data': additionalData,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'zone': zone.toJson(),
    };
  }
}

class Zone {
  int id;
  int cityId;
  int branchId;
  double price;
  dynamic createdAt;
  dynamic updatedAt;
  String zone;
  City city;
  Branch branch;

  Zone({
    required this.id,
    required this.cityId,
    required this.branchId,
    required this.price,
    this.createdAt,
    this.updatedAt,
    required this.zone,
    required this.city,
    required this.branch,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      cityId: json['city_id'],
      branchId: json['branch_id'],
      price: json['price'].toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      zone: json['zone'],
      city: City.fromJson(json['city']),
      branch: Branch.fromJson(json['branch']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'branch_id': branchId,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'zone': zone,
      'city': city.toJson(),
      'branch': branch.toJson(),
    };
  }
}

class City {
  int id;
  String name;

  City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Branch {
  int id;
  String name;
  String address;
  String email;
  String phone;
  String? image;
  String? coverImage;
  String foodPreparationTime;
  double latitude;
  String longitude;
  String coverage;
  int status;
  dynamic emailVerifiedAt;
  dynamic createdAt;
  dynamic updatedAt;
  String role;

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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'], // String? for nullable
      coverImage: json['cover_image'], // String? for nullable
      foodPreparationTime: json['food_preparion_time'] ?? 'Unknown',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: json['longitude'] ?? '',
      coverage: json['coverage'] ?? '',
      status: json['status'] ?? 0,
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'] ?? 'Unknown',
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
