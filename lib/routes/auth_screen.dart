import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../models/models.dart';

enum AuthMode { signup, login }

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
                  const Color.fromRGBO(90, 90, 243, 1),
                  const Color.fromRGBO(90, 90, 243, 1).withOpacity(0.6),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.4, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  const SizedBox(height: 100),
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
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'user_name': '',
    'email': '',
    'password': '',
    'password_confirmation': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  void dispose() {
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
    Future<void> submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.login) {
          await userData.login(_authData['email']!, _authData['password']!);
        } else {
          await userData.register(_authData['user_name']!, _authData['email']!,
              _authData['password']!);
        }
      } on MyPersonalHttpException catch (_) {
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
      duration: const Duration(milliseconds: 500),
      height: _authMode == AuthMode.signup
          ? deviceSize.height * 0.60
          : deviceSize.height * 0.40,
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.signup
            ? deviceSize.height * 0.60
            : deviceSize.height * 0.40,
      ), // _authMode == AuthMode.signup ? 320 : 260),
      width: deviceSize.width * 0.95,
      padding: EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
        top: _authMode == AuthMode.login
            ? deviceSize.width <= 360
                ? 10
                : 50
            : 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_authMode == AuthMode.signup)
                TextFormField(
                  key: UniqueKey(),
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.signup,
                  decoration: const InputDecoration(
                    hintText: 'Enter your names :',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 17,
                    ),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                  textInputAction: TextInputAction.next,
                  validator: _authMode == AuthMode.signup
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
                key: UniqueKey(),
                style: const TextStyle(color: Colors.black),
                initialValue: '@test.com',
                decoration: const InputDecoration(
                  // labelText: 'Email address',
                  hintText: 'Enter your email :',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 17,
                  ),
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
              if (_authMode == AuthMode.login) const SizedBox(height: 30),
              PasswordField(
                submit: () => submit(),
                password: _password,
                authMode: _authMode,
                confirmPassword: _confirmPassword,
                passwordController: _passwordController,
                authData: _authData,
              ),
              if (_authMode == AuthMode.signup)
                TextFormField(
                  key: UniqueKey(),
                  style: const TextStyle(color: Colors.black),
                  enabled: _authMode == AuthMode.signup,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.lock_open,
                      size: 17,
                    ),
                  ),
                  focusNode: _confirmPassword,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: _authMode == AuthMode.signup
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
                    submit();
                  },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: submit,
                  child: Text(
                      _authMode == AuthMode.login ? 'Login now' : 'Signup now'),
                ),
              TextButton(
                onPressed: _switchAuthMode,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _authMode == AuthMode.login
                            ? 'Not a member ? '
                            : 'Already a member ? ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                      TextSpan(
                        text: _authMode == AuthMode.login
                            ? 'Signup Now'
                            : 'Login Now',
                        style: const TextStyle(
                          color: Color.fromRGBO(90, 90, 243, 1),
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ],
                  ),
                ),
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
  late bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        // labelText: 'Password',
        hintText: 'Enter your Password :',
        prefixIcon: const Icon(Icons.lock_open),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: isHidden
              ? const Icon(
                  Icons.visibility_off_outlined,
                  size: 17,
                )
              : const Icon(
                  Icons.visibility_outlined,
                  size: 17,
                ),
        ),
      ),
      focusNode: widget._password,
      textInputAction: widget._authMode == AuthMode.login
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (_) {
        widget._authMode == AuthMode.login
            ? widget.submit()
            : FocusScope.of(context).requestFocus(widget._confirmPassword);
      },
      obscureText: isHidden,
      controller: widget._passwordController,
      validator: (value) {
        if (value!.isEmpty || value.length < 5) {
          return 'Password must be at least 3 characters';
        }
      },
      onSaved: (value) {
        widget._authData['password'] = value!;
      },
    );
  }
}
