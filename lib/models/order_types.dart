class OrderType {
  final int status;
  final String type;

  OrderType({required this.status,required this.type});

  factory OrderType.fromJson(Map<String, dynamic> json) => OrderType(
        status: json['status'],
        type: json['type'],
      );
}

class OrderTypes {
  final List<dynamic> orderTypes;

  OrderTypes({required this.orderTypes});

  factory OrderTypes.fromJson(Map<String, dynamic> json) =>
      OrderTypes(orderTypes: json['order_types']);
}
