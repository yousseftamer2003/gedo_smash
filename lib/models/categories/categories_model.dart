import 'package:food2go_app/models/categories/product_model.dart';

class Category {
  final String name;
  final String imageLink;
  final int id;
  final int status;
  final int activity;
  final int priority;
  final List<SubCategory> subCategories;
  final List<AddOns> addons;

  Category(
      {required this.name,
      required this.imageLink,
      required this.id,
      required this.status,
      required this.activity,
      required this.priority,
      required this.subCategories,
      required this.addons
      });

  factory Category.fromJson(Map<String, dynamic> json) {
    
    return Category(
        name: json['name'],
        imageLink: json['image_link'],
        id: json['id'],
        status: json['status'],
        activity: json['active'],
        priority: json['priority'],
        subCategories: (json['sub_categories'] as List<dynamic>)
          .map((item) => SubCategory.fromJson(item))
          .toList(),
        addons: (json['addons'] as List<dynamic>)
          .map((item) => AddOns.fromJson(item))
          .toList(),
      );
  }
}

class Categories {
  final List<dynamic> categories;

  Categories({required this.categories});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      Categories(categories: json['categories']);
}

class SubCategory {
  final int id;
  final int categoryId;
  final String name;
  final String imageLink;
  final int status;
  final int activity;
  final int priority;

  SubCategory(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.imageLink,
      required this.status,
      required this.activity,
      required this.priority});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json['id'],
        categoryId: json['category_id'],
        name: json['name'],
        imageLink: json['image_link'],
        status: json['status'],
        activity: json['active'],
        priority: json['priority'],
      );
}
