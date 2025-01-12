class Deal {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final double price;
  final int status;
  final bool daily;
  final DateTime startDate;
  final DateTime endDate;
  final List<Time> times;

  Deal({
    required this.id,
    required this.title,
    this.description,
    this.image,
    required this.price,
    required this.status,
    required this.daily,
    required this.startDate,
    required this.endDate,
    required this.times,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image_link'],
      price: json['price'].toDouble(),
      status: json['status'],
      daily: json['daily'] == 1,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      times:
          (json['times'] as List).map((time) => Time.fromJson(time)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'status': status,
      'daily': daily ? 1 : 0,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'times': times.map((time) => time.toJson()).toList(),
    };
  }
}

class Time {
  final int id;
  final int dealId;
  final String day;
  final String from;
  final String to;

  Time({
    required this.id,
    required this.dealId,
    required this.day,
    required this.from,
    required this.to,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      dealId: json['deal_id'],
      day: json['day'],
      from: json['from'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deal_id': dealId,
      'day': day,
      'from': from,
      'to': to,
    };
  }
}
