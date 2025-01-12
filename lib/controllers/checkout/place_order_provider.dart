import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import your LoginProvider
import '../../models/checkout/place_order_model.dart';
import '../Auth/login_provider.dart';

class OrderTypesAndPaymentsProvider with ChangeNotifier {
  OrderTypesAndPayments? _data;
  bool _isLoading = false;

  OrderTypesAndPayments? get data => _data;
  bool get isLoading => _isLoading;

  Future<void> fetchOrderTypesAndPayments(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    final url = Uri.parse('https://Gedobcknd.food2go.online/customer/order_type');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _data = OrderTypesAndPayments.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
