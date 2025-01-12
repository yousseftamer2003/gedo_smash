class BannerCategory {
  final int id;
  final String name;
  final String image;
  final String? bannerImage;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;
  final int priority;
  final int active;
  final String imageLink;
  final String bannerLink;

  BannerCategory({
    required this.id,
    required this.name,
    required this.image,
    this.bannerImage,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.priority,
    required this.active,
    required this.imageLink,
    required this.bannerLink,
  });
  factory BannerCategory.fromJson(Map<String, dynamic> json) {
    return BannerCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      categoryId: json['category_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      priority: json['priority'] ?? 0,
      active: json['active'] ?? false,
      imageLink: json['image_link'] ?? '',
      bannerLink: json['banner_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'banner_image': bannerImage,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'priority': priority,
      'active': active,
      'image_link': imageLink,
      'banner_link': bannerLink,
    };
  }
}

class AppBanner {
  final int id;
  final String image;
  final int order;
  final int? categoryId;
  final int? productId;
  final int? dealId;
  final int translationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageLink;
  final BannerCategory? category;

  AppBanner({
    required this.id,
    required this.image,
    required this.order,
    this.categoryId,
    this.productId,
    this.dealId,
    required this.translationId,
    required this.createdAt,
    required this.updatedAt,
    required this.imageLink,
    this.category,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      order: json['order'] ?? 0,
      categoryId: json['category_id'],
      productId: json['product_id'],
      dealId: json['deal_id'],
      translationId: json['translation_id'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      imageLink: json['image_link'] ?? '',
      category: json['category_banner'] != null
          ? BannerCategory.fromJson(json['category_banner'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'order': order,
      'category_id': categoryId,
      'product_id': productId,
      'deal_id': dealId,
      'translation_id': translationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_link': imageLink,
      'category': category?.toJson(),
    };
  }
}
