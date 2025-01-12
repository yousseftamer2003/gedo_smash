// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/delivery/views/tabs_delivery_screen.dart';
import 'package:food2go_app/models/Auth/login_model.dart';
import 'package:food2go_app/view/screens/splash_screen/maintainance_screen.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';  
import '../../view/screens/Auth/login_screen.dart'; 

class LoginProvider with ChangeNotifier {
  LoginModel? userModel;
  String? token;
  int? id;
  bool isLoading = false;

  // Method to check if a token exists in SharedPreferences
  Future<void> checkToken(BuildContext context ,bool maintainCustomer,bool maintainDelivery) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getInt('user_id');

    if (token != null) {
      final role = prefs.getString('role');
      if (role == "customer") {
        if(maintainCustomer){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TabsScreen(initialIndex: 0,)),
        );
        }else{
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MaintainanceScreen()),
        );  
        }
      } else if (role == "delivery") {
        if(maintainDelivery){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TabsDeliveryScreen()),
        );
        }else{
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MaintainanceScreen()),
        );
        }
      }
    }else{
        Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx)=> const LoginScreen())
      );
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('https://Gedobcknd.food2go.online/api/user/auth/login');
    final businussSetupProvdier = Provider.of<BusinessSetupController>(context, listen: false);
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        log(response.body.toString());
        final responseData = jsonDecode(response.body);
        userModel = LoginModel.fromJson(responseData);
        token = userModel?.token;
        id = userModel?.user!.id;
        log('Token: $token');

        if (token != null) {
          // Save the token and user role in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token!);
          await prefs.setInt('user_id', id!);
          await prefs.setString('role', userModel!.user?.role ?? '');

          if (userModel!.user?.role == "customer") {
            if(businussSetupProvdier.businessSetup!.login){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TabsScreen(initialIndex: 0,)),
            );
            }else{
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MaintainanceScreen()),
            );
            }
          } else if (userModel!.user?.role == "delivery") {
            if(businussSetupProvdier.businessSetup!.loginDelivery){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TabsDeliveryScreen()),
            );
            }else{
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MaintainanceScreen()),
            );
            }
          } else {
            showTopSnackBar(
              context,
              'Access denied: Unauthorized role.',
              Icons.cancel,
              maincolor,
              const Duration(seconds: 2),
            );
          }
        }
      } else {
        showTopSnackBar(context, 'Wrong email or password.', Icons.cancel,
            maincolor, const Duration(seconds: 2));
        throw Exception('Failed to login');
      }
    } catch (error) {
      log('error in login method: $error');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    final url = Uri.parse('https://Gedobcknd.food2go.online/api/logout');
    final String token = this.token!;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['success'] == 'You logout success') {
        // Clear token and role from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('role');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        log("You logged out successfully");
      } else {
        _showErrorSnackbar(context, 'Failed to log out. Please try again.');
      }
    } catch (error) {
      _showErrorSnackbar(
          context, 'An error occurred. Please check your network.');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
