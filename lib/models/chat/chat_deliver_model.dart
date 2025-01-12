class Chat {
  final int? id;
  final int? deliveryId;
  final int? userId;
  final String? message;
  final int? userSender;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? orderId;

  Chat({
     this.id,
     this.deliveryId,
     this.userId,
     this.message,
     this.userSender,
    this.createdAt,
    this.updatedAt,
     this.orderId,
  });

  // Factory constructor to create a Chat instance from a map (e.g., from JSON)
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      deliveryId: json['delivery_id'],
      userId: json['user_id'],
      message: json['message'],
      userSender: json['user_sender'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      orderId: json['order_id'],
    );
  }

  // Method to convert a Chat instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_id': deliveryId,
      'user_id': userId,
      'message': message,
      'user_sender': userSender,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'order_id': orderId,
    };
  }
}

class ChatResponse {
  final List<Chat> chat;

  ChatResponse({required this.chat});

  // Factory constructor to create a ChatResponse instance from JSON
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    var chatList = json['chat'] as List;
    List<Chat> chats =
        chatList.map((chatJson) => Chat.fromJson(chatJson)).toList();
    return ChatResponse(chat: chats);
  }

  // Method to convert a ChatResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'chat': chat.map((chat) => chat.toJson()).toList(),
    };
  }
}
