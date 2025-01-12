import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/profile/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GetProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfile(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if(loginProvider.token == null){
      return;
    }else{
      final String token = loginProvider.token!;
    final url =
        Uri.parse('https://Gedobcknd.food2go.online/customer/profile/profile_data');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        _userProfile = UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (error) {
      log('Error fetching profile data: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    }
  }
}
