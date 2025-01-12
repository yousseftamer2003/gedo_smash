import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/deal/deal_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DealProvider with ChangeNotifier {
  List<Deal> _deals = [];
  bool _isLoading = false;

  List<Deal> get deals => _deals;
  bool get isLoading => _isLoading;

  Future<void> fetchDeals(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    const url = 'https://Gedobcknd.food2go.online/customer/deal';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['deals'];
        _deals = data.map((json) => Deal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load deals');
      }
    } catch (error) {
      log('Error fetching deals: $error');
      _deals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
