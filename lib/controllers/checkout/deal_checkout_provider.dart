// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  String _orderResponse = '';
  String get orderResponse => _orderResponse;

  Future<void> postOrder(BuildContext context, String dealId) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    final url = Uri.parse('https://Gedobcknd.food2go.online/customer/deal/order');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'deal_id': dealId,
        }),
      );

      if (response.statusCode == 200) {
        log(response.body);
        final data = json.decode(response.body);
        _orderResponse = 'Order successful. Ref Number: ${data["ref_number"]}';
      } else {
        log(response.body);

        final data = json.decode(response.body);
        if (data["error"] != null &&
            data["error"]["deal_id"] != null &&
            data["error"]["deal_id"]
                .contains("The selected deal id is invalid.")) {
          _showExpiredDealDialog(context);
        } else {
          _orderResponse = 'Failed to place order';
        }
      }
    } catch (error) {
      _orderResponse = 'Error: $error';
    }

    notifyListeners();
  }

  void _showExpiredDealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deal Expired'),
          content: const Text('The selected deal is no longer available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
