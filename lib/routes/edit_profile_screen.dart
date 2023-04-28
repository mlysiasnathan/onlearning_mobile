import 'package:flutter/material.dart';

import '../providers/constants.dart';
import '../providers/user_services.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
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
                              child: Image.network(
                                '$assetsURL/storage/${user.image!}',
                                height: 400,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                      // key: _formKey,
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
                              },
                              initialValue: user.userName,
                              onSaved: (value) {
                                // _authData['user_name'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'email address'),
                              keyboardType: TextInputType.emailAddress,
                              initialValue: user.userEmail,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // _authData['email'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'New or Same Password'),
                              obscureText: true,
                              // controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                              },
                              onSaved: (value) {
                                // _authData['password'] = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: (value) {
                                // if (value != _passwordController.text) {
                                //   return 'Passwords do not match!';
                                // }
                              },
                              onSaved: (value) {
                                // _authData['password_confirmation'] = value!;
                              },
                            ),
                            const SizedBox(height: 20),
                            // if (_isLoading)
                            //   const CircularProgressIndicator()
                            // else
                            ElevatedButton(
                              onPressed: () {},
                              // _submit,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromRGBO(90, 90, 243, 1),
                                ),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                            const SizedBox(height: 500),
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
