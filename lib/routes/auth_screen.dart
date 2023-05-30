import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../models/models.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  const Color.fromRGBO(90, 90, 243, 1).withOpacity(0.6),
                  const Color.fromRGBO(90, 90, 243, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.6, 0.9, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 70.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-0.0),
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
                          fontWeight: FontWeight.w800,
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
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
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
    _emailFocus.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  final _emailFocus = FocusNode();
  final _password = FocusNode();
  final _confirmPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false);
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
          await userData.login(_authData['email']!, _authData['password']!);
        } else {
          await userData.register(_authData['user_name']!, _authData['email']!,
              _authData['password']!);
        }
      } on MyPersonalHttpException catch (error) {
        var errorMessage = 'Could not Authenticate you. Try later !';
        _showErrorToast(errorMessage);
      } catch (error) {
        _showErrorToast(error.toString());
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
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          right: 16,
          left: 16,
          top: _authMode == AuthMode.Login ? 90 : 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.Signup,
                  decoration: const InputDecoration(
                    hintText: 'Names :',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                  textInputAction: TextInputAction.next,
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
                decoration: const InputDecoration(
                  // labelText: 'Email address',
                  hintText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                focusNode: _emailFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_password);
                },
                textInputAction: TextInputAction.next,
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
              if (_authMode == AuthMode.Login) const SizedBox(height: 30),
              PasswordField(
                submit: () => _submit(),
                password: _password,
                authMode: _authMode,
                confirmPassword: _confirmPassword,
                passwordController: _passwordController,
                authData: _authData,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.Signup,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_open),
                  ),
                  focusNode: _confirmPassword,
                  textInputAction: TextInputAction.done,
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
                  onFieldSubmitted: (_) {
                    _submit();
                  },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submit,
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

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required FocusNode password,
    required AuthMode authMode,
    required FocusNode confirmPassword,
    required TextEditingController passwordController,
    required Map<String, String> authData,
    required this.submit,
  })  : _password = password,
        _authMode = authMode,
        _confirmPassword = confirmPassword,
        _passwordController = passwordController,
        _authData = authData;
  final Function submit;
  final FocusNode _password;
  final AuthMode _authMode;
  final FocusNode _confirmPassword;
  final TextEditingController _passwordController;
  final Map<String, String> _authData;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool isHiden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        // labelText: 'Password',
        hintText: 'Password',
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
      focusNode: widget._password,
      textInputAction: widget._authMode == AuthMode.Login
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (_) {
        widget._authMode == AuthMode.Login
            ? widget.submit()
            : FocusScope.of(context).requestFocus(widget._confirmPassword);
      },
      obscureText: isHiden,
      controller: widget._passwordController,
      validator: (value) {
        if (value!.isEmpty || value.length < 5) {
          return 'Password is too short!';
        }
      },
      onSaved: (value) {
        widget._authData['password'] = value!;
      },
    );
  }
}
