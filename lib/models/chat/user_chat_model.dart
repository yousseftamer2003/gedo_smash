class ChatResponses {
  List<UserChatModel>? chat;

  ChatResponses({this.chat});

  factory ChatResponses.fromJson(Map<String, dynamic> json) {
    return ChatResponses(
      chat: (json['chat'] as List<dynamic>?)
          ?.map((item) => UserChatModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat': chat?.map((item) => item.toJson()).toList(),
    };
  }
}

class UserChatModel {
  int? id;
  int? deliveryId;
  int? userId;
  String? message;
  int? userSender;
  String? createdAt;
  String? updatedAt;
  int? orderId;

  UserChatModel({
    this.id,
    this.deliveryId,
    this.userId,
    this.message,
    this.userSender,
    this.createdAt,
    this.updatedAt,
    this.orderId,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      id: json['id'] as int?,
      deliveryId: json['delivery_id'] as int?,
      userId: json['user_id'] as int?,
      message: json['message'] as String?,
      userSender: json['user_sender'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      orderId: json['order_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_id': deliveryId,
      'user_id': userId,
      'message': message,
      'user_sender': userSender,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'order_id': orderId,
    };
  }
}
