// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditProfileProvider with ChangeNotifier {
  Future<void> postProfileUpdate(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String bio,
    required String address,
    String? password,
    String? imagePath,
  }) async {
    const String url = 'https://Gedobcknd.food2go.online/customer/profile/update';
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      // Prepare request fields with non-empty data
      final Map<String, String> fields = {};
      if (firstName.isNotEmpty) fields['f_name'] = firstName;
      if (lastName.isNotEmpty) fields['l_name'] = lastName;
      if (email.isNotEmpty) fields['email'] = email;
      if (phone.isNotEmpty) fields['phone'] = phone;
      if (bio.isNotEmpty) fields['bio'] = bio;
      if (address.isNotEmpty) fields['address'] = address;
      if (password != null && password.isNotEmpty) {
        fields['password'] = password;
      }

      // Prepare request with image (if provided)
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(fields)
        ..headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

      if (imagePath != null && imagePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      // Send request and get response
      final response = await request.send();

      // Process response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Profile updated successfully: $responseData');
        showTopSnackBar(context, 'profle updated successfully', Icons.check,
            Colors.green, const Duration(seconds: 3));
      } else {
        final errorData = await response.stream.bytesToString();
        print(
            'Failed to update profile. Status code: ${response.statusCode}, Response: $errorData');
      }
    } catch (error) {
      print('Error occurred while updating profile: $error');
    }
  }
}
