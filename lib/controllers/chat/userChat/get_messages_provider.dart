import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/chat/user_chat_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GetMessagesProvider with ChangeNotifier {
  ChatResponses? _chatResponse;
  ChatResponses? get chatResponse => _chatResponse;

  final _controller = StreamController<ChatResponses>.broadcast();
  Stream<ChatResponses> get chatStream => _controller.stream;

  Timer? _refreshTimer;

  Future<void> fetchMessages(BuildContext context, int ordId, int delId) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    final url = 'https://Gedobcknd.food2go.online/customer/chat/$ordId/$delId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _chatResponse = ChatResponses.fromJson(data);
        _controller.add(_chatResponse!); // Add data to the stream
        notifyListeners();
      } else {
        throw Exception('Failed to get messages');
      }
    } catch (error) {
      log('Error fetching messages: $error');
    }
  }

  void startRefreshing(BuildContext context, int ordId, int delId) {
    _refreshTimer?.cancel(); // Cancel any existing timer
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchMessages(context, ordId, delId);
    });
  }

  void stopRefreshing() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _controller.close();
    super.dispose();
  }
}
