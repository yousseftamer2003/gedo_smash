class OrdersHistory {
  List<OrderHistoryModel>? orders;

  OrdersHistory({this.orders});

  factory OrdersHistory.fromJson(Map<String, dynamic> json) {
    return OrdersHistory(
      orders: json['orders'] != null
          ? List<OrderHistoryModel>.from(
              json['orders'].map((x) => OrderHistoryModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders?.map((x) => x.toJson()).toList(),
    };
  }
}

class OrderHistoryModel {
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

  OrderHistoryModel({
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

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id'],
      date: json['date'],
      userId: json['user_id'],
      branchId: json['branch_id'],
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      orderStatus: json['order_status'],
      orderType: json['order_type'],
      paymentStatus: json['payment_status'],
      totalTax: json['total_tax'] != null ? (json['total_tax'] as num).toDouble() : null,
      totalDiscount: json['total_discount'] != null ? (json['total_discount'] as num).toDouble() : null,
      paidBy: json['paid_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pos: json['pos'],
      deliveryId: json['delivery_id'],
      addressId: json['address_id'],
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
    };
  }
}
