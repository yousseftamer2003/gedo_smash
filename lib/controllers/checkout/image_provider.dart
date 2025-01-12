import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices with ChangeNotifier {
  File? _image;
  File? get image => _image;

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
      } else {
        log('No image selected');
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  String? convertImageToBase64(File image) {
    try {
      final bytes = image.readAsBytesSync();
      String base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      log('Error converting image to Base64: $e');
      return null;
    }
  }
}
