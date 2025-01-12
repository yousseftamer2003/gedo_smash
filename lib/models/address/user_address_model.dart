class Address {
  final int id;
  final int zoneId;
  final String address;
  final String street;
  final String buildingNum;
  final String floorNum;
  final String? apartment;
  final String? additionalData;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Zone zone;

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
      id: json['id'] ?? 0, // Ensure defaults for required fields
      zoneId: json['zone_id'] ?? 0,
      address: json['address'] ?? '',
      street: json['street'] ?? '',
      buildingNum: json['building_num'] ?? '',
      floorNum: json['floor_num'] ?? '',
      apartment: json['apartment'], // Nullable, so can remain as is
      additionalData: json['additional_data'] ?? 'No additional data',
      type: json['type'] ?? 'unknown', // Provide a default value for type
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      zone: Zone.fromJson(json['zone'] ?? {}), // Handle if 'zone' is null
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'zone': zone.toJson(),
    };
  }
}

class Zone {
  final int id;
  final int cityId;
  final int? branchId;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String zone;

  Zone({
    required this.id,
    required this.cityId,
    this.branchId,
    required this.price,
    this.createdAt,
    this.updatedAt,
    required this.zone,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      cityId: json['city_id'],
      branchId: json['branch_id'],
      price: json['price'].toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      zone: json['zone'] ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'branch_id': branchId,
      'price': price,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'zone': zone,
    };
  }
}
