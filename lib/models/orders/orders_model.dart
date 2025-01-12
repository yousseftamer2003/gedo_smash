class OrdersResponse {
  List<Order>? orders;

  OrdersResponse({this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => OrdersResponse(
        orders: json['orders'] != null
            ? List<Order>.from(json['orders'].map((x) => Order.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'orders': orders != null
            ? List<dynamic>.from(orders!.map((x) => x.toJson()))
            : null,
      };
}

class Order {
  int? id;
  String? date;
  int? userId;
  int? branchId;
  double? amount;
  String? orderStatus;
  String? orderType;
  String? paymentStatus;
  double? totalTax;
  double? totalDiscount;
  String? paidBy;
  String? createdAt;
  String? updatedAt;
  int? pos;
  int? deliveryId;
  int? addressId;

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
    this.createdAt,
    this.updatedAt,
    this.pos,
    this.deliveryId,
    this.addressId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        date: json['date'],
        userId: json['user_id'],
        branchId: json['branch_id'],
        amount: (json['amount'] as num?)?.toDouble(),
        orderStatus: json['order_status'],
        orderType: json['order_type'],
        paymentStatus: json['payment_status'],
        totalTax: (json['total_tax'] as num?)?.toDouble(),
        totalDiscount: (json['total_discount'] as num?)?.toDouble(),
        paidBy: json['paid_by'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        pos: json['pos'],
        deliveryId: json['delivery_id'],
        addressId: json['address_id'],
      );

  Map<String, dynamic> toJson() => {
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
      };
}