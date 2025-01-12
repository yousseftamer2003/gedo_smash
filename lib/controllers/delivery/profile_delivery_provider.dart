import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../models/delivery/profile_delivery_model.dart';
import '../Auth/login_provider.dart';

class DeliveryUserProvider with ChangeNotifier {
  DeliveryUser? _user;
  bool _isLoading = false;

  DeliveryUser? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final String? token = loginProvider.token;

      final url = Uri.parse(
          'https://Gedobcknd.food2go.online/delivery/profile/profile_data');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        _user = DeliveryUser.fromJson(data);
      } else {
        throw Exception('Failed to load user data');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
