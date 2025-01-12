import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/delivery/orders_delivery_model.dart';
import '../Auth/login_provider.dart';

class OrderdeliveryProvider with ChangeNotifier {
  final String _baseUrl = 'https://Gedobcknd.food2go.online/delivery/orders';
  final String _updateOrderUrl =
      'https://Gedobcknd.food2go.online/delivery/orders/status';

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final String? token = loginProvider.token;

      if (token == null || token.isEmpty) {
        throw Exception('User is not logged in or token is missing');
      }

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> ordersJson = data['orders'] ?? [];

        _orders = ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        log(response.body);
        log(response.statusCode.toString());
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      log('Error fetching orders: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(
      BuildContext context, int orderId, String orderStatus) async {
    try {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final String? token = loginProvider.token;

      if (token == null || token.isEmpty) {
        throw Exception('User is not logged in or token is missing');
      }

      // Construct the URL with parameters
      final url = Uri.parse(
          '$_updateOrderUrl?order_id=$orderId&order_status=$orderStatus');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        log('Order status updated successfully: ${response.body}');
      } else {
        log(response.statusCode.toString());
        log('Failed to update order status: ${response.body}');
        throw Exception('Failed to update order status');
      }
    } catch (error) {
      log(error.toString());
      log('Error updating order status: $error');
      rethrow;
    }
  }
}
