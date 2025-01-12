// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/Auth/login_model.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider with ChangeNotifier {
  LoginModel? signUpModel;
  String? errorMessage; // Store error messages
  bool isLoading = false; // Store loading state

  Future<void> signUpUser({
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
    required String confPassword,
    BuildContext? context,
  }) async {
    const String url = 'https://Gedobcknd.food2go.online/api/user/auth/signup';
    errorMessage = null; // Reset the error message at the start

    // Prepare the request body
    final Map<String, dynamic> body = {
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'password': password,
      'conf_password': confPassword,
    };

    isLoading = true; // Set loading to true before the request
    notifyListeners(); // Notify listeners about the loading state change

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), 
      );

      // Check the response status
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        signUpModel = LoginModel.fromJson(responseData);
        final tokenProvider = Provider.of<LoginProvider>(context!,listen: false);
        tokenProvider.token = signUpModel!.token;
        final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', signUpModel!.user!.token!);
          await prefs.setString('role', signUpModel!.user?.role ?? '');
        print('User signed up successfully: ${signUpModel?.user?.name}');
        log('response body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Sign up successful! Welcome, ${signUpModel?.user?.name}.'),
          ),
        );
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TabsScreen(initialIndex: 0,)));
          },
        );
      } else {
        // Handle errors
        final responseData = jsonDecode(response.body);
        String errorMsg = 'Sign up failed.';

        // Check if there are validation errors
        if (responseData['errors'] != null) {
          // Collect all error messages from the response
          final List<String> errorMessages = [];
          responseData['errors'].forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => '$key: $e').toList());
            }
          });
          errorMsg = errorMessages.join('\n'); // Join error messages
        }

        errorMessage = errorMsg;
        print('Failed to sign up. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Show the combined error messages in the Snackbar
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      // Handle exceptions
      errorMessage = 'Error occurred during signup: $e';
      print(errorMessage);

      // Show error message in the Snackbar if context is provided
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage!)),
        );
      }
    } finally {
      isLoading = false; // Set loading to false after the request
      notifyListeners(); // Notify listeners about the loading state change
    }
  }
}
