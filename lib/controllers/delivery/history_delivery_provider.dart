import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/delivery/history_delivery_model.dart';

class OrderHistoryProvider extends ChangeNotifier {
  OrderHistory? _orderHistory;
  bool _isLoading = false;
  String _errorMessage = '';

  OrderHistory? get orderHistory => _orderHistory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Function to fetch order history data
  Future<void> fetchOrderHistory(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String? token = loginProvider.token;

    if (token == null) {
      _errorMessage = 'No token found';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://Gedobcknd.food2go.online/delivery/orders/history');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log(response.body);
        final data = json.decode(response.body);
        _orderHistory = OrderHistory.fromJson(data);
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load order history';
        _orderHistory = null;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _orderHistory = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
