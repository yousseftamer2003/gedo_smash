// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/profile/edit_profile_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage; // To store the selected image

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    await Provider.of<GetProfileProvider>(context, listen: false)
        .fetchUserProfile(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profilesProvider = Provider.of<GetProfileProvider>(context);

    // Show loading indicator until userProfile is available
    if (profilesProvider.userProfile == null) {
      return Scaffold(
        appBar: buildAppBar(context, 'Edit profile'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await _fetchUserProfile(); // Fetch the user profile data when popping the screen
        return true; // Allow the pop action
      },
      child: Scaffold(
        appBar: buildAppBar(context, 'Edit profile'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!) as ImageProvider
                                  : (profilesProvider.userProfile?.imageLink != null
                                      ? NetworkImage(profilesProvider.userProfile!.imageLink!)
                                      : const AssetImage('assets/default_avatar.png')), // Fallback image if no image is found
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                backgroundColor: maincolor,
                                radius: 16,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.camera_alt),
                                              title: const Text('Take a photo'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                _pickImageFromCamera();
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.photo),
                                              title: const Text('Choose from gallery'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                _pickImageFromGallery();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profilesProvider.userProfile?.name ?? 'Name not available',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profilesProvider.userProfile?.bio ?? 'Bio not available',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('First Name', fnameController),
                  const SizedBox(height: 16),
                  _buildTextField('Last Name', lnameController),
                  const SizedBox(height: 16),
                  _buildTextField('Email', emailController),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Phone', phoneController),
                  const SizedBox(height: 16),
                  _buildTextField('Bio', bioController),
                  const SizedBox(height: 16),
                  _buildTextField('Address', addressController),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      // Call provider method to save profile
                      await Provider.of<EditProfileProvider>(context, listen: false)
                          .postProfileUpdate(
                        context,
                        firstName: fnameController.text,
                        lastName: lnameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                        address: addressController.text,
                        password: passController.text,
                        imagePath: _selectedImage?.path,
                      );
                      // Refresh user profile data after update
                      await _fetchUserProfile();
                      _clearTextFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maincolor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // Helper method to clear text fields after save
  void _clearTextFields() {
    fnameController.clear();
    lnameController.clear();
    emailController.clear();
    passController.clear();
    phoneController.clear();
    bioController.clear();
    addressController.clear();
  }
}
