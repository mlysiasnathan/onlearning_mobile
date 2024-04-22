import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

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

  // void _showErrorDialog(String message) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  //       title: const Text(
  //         'An error occurred !',
  //         style: TextStyle(color: Colors.red),
  //       ),
  //       content: Text(message),
  //       actionsAlignment: MainAxisAlignment.center,
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(ctx);
  //           },
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        closeIconColor: Colors.white,
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  final _emailFocus = FocusNode();
  final _password = FocusNode();
  final _confirmPassword = FocusNode();
  @override
  void dispose() {
    _emailFocus.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final userData = Provider.of<Auth>(context);
    void goBack() {
      Timer(Duration.zero, () {
        Navigator.pop(context);
      });
    }

    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        // Invalid!
        return;
      }
      if (_storedImage == null) {
        _showErrorToast('Select a new Profile Picture');
        return;
      }
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {
        // Update user
        await userData.updateUserProfile(
          _updateData['user_name_update'].toString(),
          _updateData['email_update'].toString(),
          _updateData['password_update'].toString(),
          _storedImage!,
        );
        goBack();
      } on MyPersonalHttpException catch (error) {
        const errorMessage = 'Could not Update your profile. Try later !';
        _showErrorToast(errorMessage);
      } catch (error) {
        _showErrorToast(error.toString());
      }

      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const CustomAppBar(title: 'Profile'),
          SliverList(
            delegate: SliverChildListDelegate(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              [
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
                  padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Names :',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Fill your names here!';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            textInputAction: TextInputAction.next,
                            initialValue: userData.user.userName,
                            onSaved: (value) {
                              _updateData['user_name_update'] = value!;
                            },
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              // labelText: 'Email address',
                              hintText: 'Email address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            initialValue: userData.user.userEmail,
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_password);
                            },
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
                          const SizedBox(height: 5),

                          PasswordFieldUpdate(
                            submit: () => _submit(),
                            password: _password,
                            confirmPassword: _confirmPassword,
                            passwordController: _passwordController,
                            updateData: _updateData,
                          ),
                          const SizedBox(height: 5),

                          // TextFormField(
                          //   decoration: const InputDecoration(
                          //       labelText: 'New or Same Password'),
                          //   obscureText: true,
                          //   controller: _passwordController,
                          //   textInputAction: TextInputAction.next,
                          //   focusNode: _password,
                          //   onFieldSubmitted: (_) {
                          //     FocusScope.of(context)
                          //         .requestFocus(_confirmPassword);
                          //   },
                          //   validator: (value) {
                          //     if (value!.isEmpty || value.length < 5) {
                          //       return 'Password is too short!';
                          //     }
                          //     return null;
                          //   },
                          //   onSaved: (value) {
                          //     _updateData['password_update'] = value!;
                          //   },
                          // ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock_open),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmPassword,
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
                            onFieldSubmitted: (_) {
                              _submit();
                            },
                          ),

                          const SizedBox(height: 25),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            ElevatedButton(
                              onPressed: _submit,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
    primaryColor,
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
        ],
      ),
    );
  }
}

class PasswordFieldUpdate extends StatefulWidget {
  const PasswordFieldUpdate({
    super.key,
    required FocusNode password,
    required FocusNode confirmPassword,
    required TextEditingController passwordController,
    required Map<String, String> updateData,
    required this.submit,
  })  : _password = password,
        _confirmPassword = confirmPassword,
        _passwordController = passwordController,
        _updateData = updateData;
  final Function submit;
  final FocusNode _password;
  final FocusNode _confirmPassword;
  final TextEditingController _passwordController;
  final Map<String, String> _updateData;

  @override
  State<PasswordFieldUpdate> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordFieldUpdate> {
  late bool isHiden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        // labelText: 'Password',
        hintText: 'New or Same Password',
        prefixIcon: const Icon(Icons.lock_open),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHiden = !isHiden;
            });
          },
          icon: isHiden
              ? const Icon(Icons.visibility_outlined)
              : const Icon(Icons.visibility_off_outlined),
        ),
      ),
      obscureText: isHiden,
      controller: widget._passwordController,
      textInputAction: TextInputAction.next,
      focusNode: widget._password,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(widget._confirmPassword);
      },
      validator: (value) {
        if (value!.isEmpty || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        widget._updateData['password_update'] = value!;
      },
    );
  }
}
