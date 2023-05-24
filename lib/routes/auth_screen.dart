import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/users_provider.dart';
import '../models/http_exceptions.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import './categories_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  Color.fromRGBO(90, 90, 243, 1),
                  Color.fromRGBO(90, 90, 243, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0.1, 0.6, 0.9, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      // margin: const EdgeInsets.only(bottom: 10.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 80.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(90, 90, 243, 1),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'Onlearning',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
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

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'user_name': '',
    'email': '',
    'password': '',
    'password_confirmation': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;
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
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _savedAndRedirect(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('user_id', user.userId ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        (route) => false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
      begin: const Size(double.infinity, 350),
      end: const Size(double.infinity, 500),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        if (_authMode == AuthMode.Login) {
          // Log user in
          ApiResponse response =
              await userData.login(_authData['email']!, _authData['password']!);
          if (response.errors == null) {
            _savedAndRedirect(response.data as User);
          } else {
            _showErrorDialog(response.errors.toString());
          }
          // await Provider.of<Auth>(context, listen: false)
          //     .login(_authData['email']!, _authData['password']!);
        } else {
          // Sign user up
          ApiResponse response = await userData.register(
              _authData['user_name']!,
              _authData['email']!,
              _authData['password']!);
          if (response.errors == null) {
            _savedAndRedirect(response.data as User);
          } else {
            _showErrorDialog(response.errors.toString());
          }
          // await Provider.of<Auth>(context, listen: false)
          //     .signup(_authData['email']!, _authData['password']!);
        }
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
        const errorMessage = 'Could not Authenticate you. Try later !';
        _showErrorDialog(errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }

    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _authMode == AuthMode.Signup ? 500 : 350,
      constraints: BoxConstraints(
          minHeight: _heightAnimation
              .value.height), // _authMode == AuthMode.Signup ? 320 : 260),
      width: deviceSize.width * 0.95,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.Signup,
                  decoration: const InputDecoration(labelText: 'Names :'),
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value!.isEmpty) {
                            return 'Fill your names here!';
                          }
                        }
                      : null,
                  onSaved: (value) {
                    _authData['user_name'] = value!;
                  },
                ),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                initialValue: '@test.com',
                decoration: const InputDecoration(labelText: 'email address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.Signup,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        }
                      : null,
                  onSaved: (value) {
                    _authData['password_confirmation'] = value!;
                  },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateColor.resolveWith(
                  //     (states) => const Color.fromRGBO(90, 90, 243, 1),
                  //   ),
                  // ),
                  child: Text(
                      _authMode == AuthMode.Login ? 'Login now' : 'Signup now'),
                ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                    '${_authMode == AuthMode.Login ? 'Signup' : 'Login'} instead !'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
