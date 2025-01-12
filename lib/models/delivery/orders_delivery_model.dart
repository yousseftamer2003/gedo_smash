class Order {
  final int? id;
  final String? date;
  final int? userId;
  final int? branchId;
  final double? amount;
  String? orderStatus; // Removed `final` to make it mutable
  final String? orderType;
  final String? paymentStatus;
  final double? totalTax;
  final double? totalDiscount;
  final String? paidBy;
  final int? pos;
  final int? deliveryId;
  final int? addressId;
  final String? notes;
  final double? coupondiscount;
  final List<Item>? items;
  final Address? address;
  final List<OrderDetail>? details;
  final User? user;

  Order({
    this.id,
    this.date,
    this.userId,
    this.branchId,
    this.amount,
    this.orderStatus,
    this.orderType,
    this.paymentStatus,
    this.totalTax,
    this.totalDiscount,
    this.paidBy,
    this.pos,
    this.deliveryId,
    this.addressId,
    this.notes,
    this.coupondiscount,
    this.items,
    this.address,
    this.details,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      date: json['date'] as String?,
      userId: json['user_id'] as int?,
      branchId: json['branch_id'] as int?,
      amount: (json['amount'] as num?)?.toDouble(),
      orderStatus: json['order_status'] as String?,
      orderType: json['order_type'] as String?,
      paymentStatus: json['payment_status'] as String?,
      totalTax: (json['total_tax'] as num?)?.toDouble(),
      totalDiscount: (json['total_discount'] as num?)?.toDouble(),
      paidBy: json['paid_by'] as String?,
      pos: json['pos'] as int?,
      deliveryId: json['delivery_id'] as int?,
      addressId: json['address_id'] as int?,
      notes: json['notes'] as String?,
      coupondiscount: (json['coupon_discount'] as num?)?.toDouble(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList(),
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      details: (json['details'] as List<dynamic>?)
          ?.map((detail) => OrderDetail.fromJson(detail))
          .toList(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  void setOrderStatus(String newStatus) {
    orderStatus = newStatus;
  }
}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? image;
  final double? wallet;
  final int? status;
  final String? bio;
  final String? role;
  final String? code;
  final String? imageLink;
  final String? name;
  final String? type;
  final int? points;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.wallet,
    this.status,
    this.bio,
    this.role,
    this.code,
    this.imageLink,
    this.name,
    this.type,
    this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['f_name'] as String?,
      lastName: json['l_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      wallet: (json['wallet'] as num?)?.toDouble(),
      status: json['status'] as int?,
      bio: json['bio'] as String?,
      role: json['role'] as String?,
      code: json['code'] as String?,
      imageLink: json['image_link'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      points: json['points'] as int?,
    );
  }
}

class Item {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final int? categoryId;
  final int? subCategoryId;
  final String? itemType;
  final String? stockType;
  final int? number;
  final double? price;
  final int? productTimeStatus;
  final String? from;
  final String? to;
  final int? discountId;
  final int? taxId;
  final int? status;
  final int? recommended;
  final int? points;
  final int? count;
  final List<Addon>? addons; // Added a list for Addon

  Item({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.subCategoryId,
    this.itemType,
    this.stockType,
    this.number,
    this.price,
    this.productTimeStatus,
    this.from,
    this.to,
    this.discountId,
    this.taxId,
    this.status,
    this.recommended,
    this.points,
    this.count,
    this.addons, // Add this parameter to the constructor
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    var addonsJson = json['addons'] as List?; // Parsing the 'addons' list

    return Item(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      categoryId: json['category_id'] as int?,
      subCategoryId: json['sub_category_id'] as int?,
      itemType: json['item_type'] as String?,
      stockType: json['stock_type'] as String?,
      number: json['number'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      productTimeStatus: json['product_time_status'] as int?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      discountId: json['discount_id'] as int?,
      taxId: json['tax_id'] as int?,
      status: json['status'] as int?,
      recommended: json['recommended'] as int?,
      points: json['points'] as int?,
      count: json['count'] as int?,
      addons: addonsJson != null
          ? addonsJson.map((addonJson) => Addon.fromJson(addonJson)).toList()
          : [], // Parsing each Addon from the list
    );
  }
}

class Addon {
  final int? id;
  final String? name;
  final double? price;
  final int? taxId;
  final int? quantityAdd;
  final int? count;

  Addon({
    this.id,
    this.name,
    this.price,
    this.taxId,
    this.quantityAdd,
    this.count,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      taxId: json['tax_id'] as int?,
      quantityAdd: json['quantity_add'] as int?,
      count: json['count'] as int?,
    );
  }
}

class Address {
  final int? id;
  final int? zoneId;
  final String? address;
  final String? street;
  final String? buildingNum;
  final String? floorNum;
  final String? apartment;
  final String? additionalData;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Zone? zone;

  Address({
    this.id,
    this.zoneId,
    this.address,
    this.street,
    this.buildingNum,
    this.floorNum,
    this.apartment,
    this.additionalData,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.zone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int?,
      zoneId: json['zone_id'] as int?,
      address: json['address'] as String?,
      street: json['street'] as String?,
      buildingNum: json['building_num'] as String?,
      floorNum: json['floor_num'] as String?,
      apartment: json['apartment'] as String?,
      additionalData: json['additional_data'] as String?,
      type: json['type'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      zone: json['zone'] != null ? Zone.fromJson(json['zone']) : null,
    );
  }
}

class Zone {
  final int? id;
  final int? cityId;
  final int? branchId;
  final double? price;
  final String? zone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final City? city;
  final Branch? branch; // Add Branch here

  Zone({
    this.id,
    this.cityId,
    this.branchId,
    this.price,
    this.zone,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.branch, // Include Branch in the constructor
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as int?,
      cityId: json['city_id'] as int?,
      branchId: json['branch_id'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      zone: json['zone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      branch: json['branch'] != null
          ? Branch.fromJson(json['branch'])
          : null, // Parse Branch here
    );
  }
}

class City {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  City({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int?,
      name: json['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class Branch {
  final int? id;
  final String? name;
  final String? address;
  final String? email;
  final String? phone;
  final String? image;
  final String? coverImage;
  final String? foodPreparationTime;
  final double? latitude;
  final String? longitude;
  final String? coverage;
  final int? status;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Branch({
    this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.image,
    this.coverImage,
    this.foodPreparationTime,
    this.latitude,
    this.longitude,
    this.coverage,
    this.status,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      coverImage: json['cover_image'] as String?,
      foodPreparationTime: json['food_preparion_time'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: json['longitude'] as String?,
      coverage: json['coverage'] as String?,
      status: json['status'] as int?,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class OrderDetail {
  final int? id;
  final int? itemId;
  final int? orderId;
  final int? quantity;
  final double? price;
  final double? tax;
  final double? discount;
  final Product? product;

  OrderDetail({
    this.id,
    this.itemId,
    this.orderId,
    this.quantity,
    this.price,
    this.tax,
    this.discount,
    this.product,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] as int?,
      itemId: json['item_id'] as int?,
      orderId: json['order_id'] as int?,
      quantity: json['quantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }
}

class Product {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? image;
  final int? stock;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'] as String?,
      stock: json['stock'] as int?,
    );
  }
}
