import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/api_response.dart';
import '../models/http_exceptions.dart';
import '../providers/constants.dart';
import '../providers/users_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  File? _storedImage;
  final Map<String, String> _updateData = {
    'user_name_update': '',
    'email_update': '',
    'password_update': '',
    'password_confirmation_update': ''
  };
  var _isLoading = false;
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occurred !'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(ctx);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);

    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {
        // Update user
        ApiResponse response = await userData.updateUserProfile(
          _updateData['user_name_update'].toString(),
          _updateData['email_update'].toString(),
          _updateData['password_update'].toString(),
          _storedImage!,
        );
        if (response.errors == null) {
          _showErrorDialog(response.data.toString());
        } else {
          _showErrorDialog(response.errors.toString());
        }
        // await Provider.of<Auth>(context, listen: false)
        //     .login(_updateData['email']!, _updateData['password']!);
      } on MyPersonalHttpException catch (error) {
        var errorMessage = 'Authentication failed !';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email is already taken !';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This email is invalid !';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak !';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with this email !';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'This password is invalid !';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Could not Update your profile. Try later !';
        _showErrorDialog(errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const CustomAppBar(title: 'Profile', image: null),
          SliverFillRemaining(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: _storedImage == null
                                  ? Image.network(
                                      '$assetsURL/storage/${userData.user.image!}',
                                      height: 400,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      _storedImage!,
                                      height: 400,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            TextButton.icon(
                              label: const Text('Take picture'),
                              onPressed: _takePicture,
                              icon: const Icon(Icons.camera),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(19),
                          child: Text('Student'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Names :'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Fill your names here!';
                                }
                                return null;
                              },
                              initialValue: userData.user.userName,
                              onSaved: (value) {
                                _updateData['user_name_update'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'email address'),
                              keyboardType: TextInputType.emailAddress,
                              initialValue: userData.user.userEmail,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updateData['email_update'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'New or Same Password'),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updateData['password_update'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updateData['password_confirmation_update'] =
                                    value!;
                              },
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              ElevatedButton(
                                onPressed: _submit,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) =>
                                        const Color.fromRGBO(90, 90, 243, 1),
                                  ),
                                ),
                                child: const Text('Edit Profile'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
