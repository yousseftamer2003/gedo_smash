import 'package:food2go_app/models/categories/product_model.dart';

class CartItem {
  final Product product;
  final List<Extra> extra;
  final List<Option> options;
  final List<AddOns> addons;
  final List<Excludes> excludes;

  CartItem({
    required this.product,
    required this.extra,
    required this.options,
    required this.addons,
    required this.excludes,
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'extra': extra.map((e) => e.toJson()).toList(),
      'options': options.map((o) => o.toJson()).toList(),
      'addons': addons.map((a) => a.toJson()).toList(),
      'excludes': excludes.map((ex) => ex.toJson()).toList(),
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      extra: (json['extra'] as List<dynamic>)
          .map((e) => Extra.fromJson(e))
          .toList(),
      options: (json['options'] as List<dynamic>)
          .map((o) => Option.fromJson(o))
          .toList(),
      addons: (json['addons'] as List<dynamic>)
          .map((a) => AddOns.fromJson(a))
          .toList(),
      excludes: (json['excludes'] as List<dynamic>)
          .map((ex) => Excludes.fromJson(ex))
          .toList(),
    );
  }
}

// class Cart {
//   final List<CartItem> cartItems;
//   final double totalPrice;
//   final String date;
//   final double totalTax;
//   final String orderType;

//   Cart({
//     required this.cartItems,
//     required this.totalPrice,
//     required this.date,
//     required this.totalTax,
//     required this.orderType,
//   });

//   // Convert Cart to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'cartItems': cartItems.map((item) => item.toJson()).toList(),
//       'totalPrice': totalPrice,
//       'date': date,

//       'totalTax': totalTax,
//       'orderType': orderType,
//     };
//   }

//   // Create Cart from JSON
//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       cartItems: (json['cartItems'] as List<dynamic>)
//           .map((item) => CartItem.fromJson(item))
//           .toList(),
//       totalPrice: json['totalPrice'],
//       date: json['date'],
//       totalTax: json['totalTax'],
//       orderType: json['orderType'],
//     );
//   }
// }
