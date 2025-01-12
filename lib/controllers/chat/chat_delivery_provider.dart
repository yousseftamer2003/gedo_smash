// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/chat/chat_deliver_model.dart';
import '../Auth/login_provider.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  final StreamController<List<Chat>> _chatStreamController =
      StreamController<List<Chat>>.broadcast();

  List<Chat> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<Chat>> get chatStream => _chatStreamController.stream;

  Timer? _chatFetchTimer;

  Future<void> fetchChat(BuildContext context, int orderId, int userId) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;
    final String url =
        'https://Gedobcknd.food2go.online/delivery/chat/$orderId/$userId';

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['chat'] != null) {
          _messages = List<Chat>.from(
            data['chat'].map((json) => Chat.fromJson(json)),
          );
          _messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          _chatStreamController.add(_messages);
        } else {
          log('No messages found in response');
          _errorMessage = 'No messages found in response';
        }
      } else {
        _errorMessage = 'Failed to load chat messages';
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(
      BuildContext context, int orderId, int userId, String message) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;
    const String url = 'https://Gedobcknd.food2go.online/delivery/chat/send';

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'order_id': orderId,
          'user_id': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        log('Message sent successfully');
        // ignore: use_build_context_synchronously
        fetchChat(context, orderId, userId);
      } else {
        _errorMessage = 'Failed to send message';
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startFetchingChat(BuildContext context, int orderId, int userId) {
    fetchChat(context, orderId, userId);
    _chatFetchTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchChat(context, orderId, userId);
    });
  }

  void stopFetchingChat() {
    _chatFetchTimer?.cancel();
    _chatStreamController.close();
  }
}
