// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SendMessageProvider with ChangeNotifier {
  Future<void> sendMessages(
      BuildContext context, int ordId, int delId, String message) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String? token = loginProvider.token;

    if (token == null) {
      log('Error: Missing authentication token');
      return;
    }

    const url = 'https://Gedobcknd.food2go.online/customer/chat/send';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Added content type for clarity
        },
        body: jsonEncode({
          'order_id': ordId,
          'delivery_id': delId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log('Message sent successfully: $data');
        notifyListeners();
      } else {
        log('Failed to send message: ${response.statusCode}');
        throw Exception('Failed to send message');
      }
    } catch (error) {
      log('Error sending message: $error');
    }
  }
}
