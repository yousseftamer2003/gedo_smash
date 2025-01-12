// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/orders/orders_model.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class OrdersProvider with ChangeNotifier {
  OrdersResponse? _ordersResponse;
  OrdersResponse? get orderresponse => _ordersResponse;
  String? _cancelTime;
  String? get cancelTime => _cancelTime;

  // Method to fetch orders from the API
  Future<void> fetchOrders(BuildContext context) async {
    const url = 'https://Gedobcknd.food2go.online/customer/orders';
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
        _ordersResponse = OrdersResponse.fromJson(data);
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
      _ordersResponse = null;
      notifyListeners();
    }
  }

  Future<void> cancelOrder(BuildContext context, int orderId) async {
    final url = Uri.parse(
        'https://Gedobcknd.food2go.online/customer/orders/cancel/$orderId');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        log("$orderId canceled");
        showTopSnackBar(context, 'order is cancelled successfully', Icons.check,
            Colors.green, const Duration(seconds: 3));
        // Remove the canceled order from the ongoing orders list
        _ordersResponse?.orders?.removeWhere((order) => order.id == orderId);
        notifyListeners(); // Notify listeners to rebuild the widget
      } else {
        throw Exception('Failed to cancel order');
      }
    } catch (error) {
      print('Error canceling order: $error');
    }
  }

  Future<void> fetchOrdersCancelTime(BuildContext context) async {
    const url = 'https://Gedobcknd.food2go.online/customer/orders/cancel_time';
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
        _cancelTime = data['cancel_time']; // Extract and store the cancel time
        log("Orders cancel time fetched successfully: $_cancelTime");
        notifyListeners(); // Notify listeners to rebuild any widgets listening to this provider
      } else {
        print(
            'Failed to load cancel time with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load cancel time');
      }
    } catch (error) {
      print('Error fetching cancel time: $error');
      _cancelTime = null; // Optionally reset cancel time in case of error
      notifyListeners();
    }
  }
}
