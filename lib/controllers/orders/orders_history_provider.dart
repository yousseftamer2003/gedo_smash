// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/orders/order_history_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrdersHistoryProvider with ChangeNotifier {
  OrdersHistory? _ordersHistory;
  OrdersHistory? get ordersHistory => _ordersHistory;

  Future<void> fetchOrdershistory(BuildContext context) async {
    const url = 'https://Gedobcknd.food2go.online/customer/orders/history';
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _ordersHistory = OrdersHistory.fromJson(data);
        log("Orders fetched successfully");
        notifyListeners(); // Notify listeners to rebuild any widgets listening to this provider
      } else {
        print('Failed to load orders with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error fetching orders: $error');
      // Optionally, set _ordersResponse to null in case of error to reset the data
      _ordersHistory = null;
      notifyListeners();
    }
  }
}
