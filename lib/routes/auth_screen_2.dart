import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exceptions.dart';
import '../providers/auth_provider.dart';

enum AuthMode { login, signup, forgot }

class AuthScreen2 extends StatefulWidget {
  const AuthScreen2({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen2> createState() => _AuthScreen2State();
}

class _AuthScreen2State extends State<AuthScreen2> {
  final List<Map<String, dynamic>> demoData = [
    {'title': 'Authentication', 'desc': 'Welcome Back'},
    {'title': 'Registration', 'desc': 'First time with us ?'},
    {'title': 'Verification', 'desc': 'Checking of account'},
  ];
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'user_name': '',
    'email': '',
    'password': '',
    'password_confirmation': '',
    'phone': '',
    'otp': ''
  };
  var _isLoading = false;
  var _isGoogleLoading = false;
  var _isAppleLoading = false;
  var _isPhoneLoading = false;
  var _isFaceBookLoading = false;
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
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

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

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: deviceSize.height * 0.01),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [theme.primaryColor, theme.primaryColorLight],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: deviceSize.height * 0.11),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demoData[_authMode.index]['title'],
                          style: TextStyle(
                            color: theme.colorScheme.background,
                            fontSize: deviceSize.width * 0.09,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: deviceSize.height * 0.009),
                        Text(
                          demoData[_authMode.index]['desc'],
                          style: TextStyle(
                            color: theme.colorScheme.background,
                            fontSize: deviceSize.width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    transform: Matrix4.rotationZ(_authMode == AuthMode.login
                        ? 14 * pi / 180
                        : -14 * pi / 180)
                      ..translate(-0.0),
                    child: Icon(
                      _authMode == AuthMode.login
                          ? Icons.lock
                          : _authMode == AuthMode.signup
                              ? Icons.lock_open
                              : Icons.mark_email_read,
                      color: theme.colorScheme.background,
                      size: deviceSize.width * 0.15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: deviceSize.height * 0.015),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: deviceSize.height * 0.1),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (_authMode == AuthMode.forgot)
                              TextFormField(
                                key: const ValueKey('email'),
                                initialValue: '@test.com',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  hintText:
                                      'Enter your email for verification :',
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['email'] = value!.trim();
                                },
                              ),
                            if (_authMode == AuthMode.signup)
                              TextFormField(
                                key: const ValueKey('names'),
                                enabled: _authMode == AuthMode.signup,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Enter your names :',
                                ),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocus);
                                },
                                textInputAction: TextInputAction.next,
                                validator: _authMode == AuthMode.signup
                                    ? (value) {
                                        if (value!.isEmpty) {
                                          return 'Fill your names here!';
                                        }
                                        return null;
                                      }
                                    : null,
                                onSaved: (value) {
                                  _authData['user_name'] = value!.trim();
                                },
                              ),
                            if (_authMode != AuthMode.forgot)
                              SizedBox(height: deviceSize.height * 0.015),
                            if (_authMode != AuthMode.forgot)
                              TextFormField(
                                key: const ValueKey('mail'),
                                initialValue: '@test.com',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  hintText: 'Enter your email :',
                                ),
                                focusNode: _emailFocus,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_password);
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
                                  _authData['email'] = value!.trim();
                                },
                              ),
                            if (_authMode != AuthMode.forgot)
                              SizedBox(height: deviceSize.height * 0.015),
                            if (_authMode == AuthMode.login)
                              SizedBox(height: deviceSize.height * 0.015),
                            if (_authMode != AuthMode.forgot)
                              PasswordField(
                                submit: () => submit(),
                                password: _password,
                                authMode: _authMode,
                                confirmPassword: _confirmPassword,
                                passwordController: _passwordController,
                                authData: _authData,
                              ),
                            if (_authMode != AuthMode.forgot)
                              SizedBox(height: deviceSize.height * 0.015),
                            if (_authMode == AuthMode.signup)
                              TextFormField(
                                key: const ValueKey('conf'),
                                enabled: _authMode == AuthMode.signup,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open),
                                  hintText: 'Confirm Password :',
                                ),
                                focusNode: _confirmPassword,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                validator: _authMode == AuthMode.signup
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                        return null;
                                      }
                                    : null,
                                onSaved: (value) {
                                  _authData['password_confirmation'] =
                                      value!.trim();
                                },
                                onFieldSubmitted: (_) {
                                  submit();
                                },
                              ),
                            if (_authMode == AuthMode.login)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _authMode = AuthMode.forgot;
                                      });
                                    },
                                    child: Text(
                                      'Forgot password ?',
                                      style:
                                          TextStyle(color: Colors.red.shade900),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: deviceSize.height * 0.02),
                          ],
                        ),
                      ),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          width: deviceSize.width * 0.8,
                          child: ElevatedButton(
                            onPressed: submit,
                            child: Text(
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              _authMode != AuthMode.forgot
                                  ? _authMode == AuthMode.login
                                      ? 'LOG IN'
                                      : 'SIGN UP'
                                  : 'GET RESET LINK',
                            ),
                          ),
                        ),
                      if (_authMode == AuthMode.login)
                        SizedBox(height: deviceSize.height * 0.02),
                      if (_authMode == AuthMode.login)
                        const Text('Continue with social media'),
                      if (_authMode == AuthMode.login)
                        SizedBox(height: deviceSize.height * 0.02),
                      if (_authMode == AuthMode.login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _isGoogleLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : TextButton.icon(
                                      onPressed: () async {
                                        setState(() {
                                          _isGoogleLoading = true;
                                        });
                                      },
                                      icon: const Icon(Icons.g_translate),
                                      label: const Text('Google'),
                                    ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _isAppleLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isAppleLoading = true;
                                        });
                                      },
                                      icon: const Icon(Icons.apple),
                                      label: const Text('Apple'),
                                    ),
                            ),
                          ],
                        ),
                      if (_authMode == AuthMode.login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _isFaceBookLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isFaceBookLoading = true;
                                        });
                                      },
                                      icon: const Icon(Icons.facebook),
                                      label: const Text('Facebook'),
                                    ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _isPhoneLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          showDialog<void>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              elevation: 10,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10,
                                              ),
                                              // backgroundColor: Colors.white.withOpacity(0.9),
                                              alignment: Alignment.center,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),

                                              content: SizedBox(
                                                height:
                                                    deviceSize.height * 0.35,
                                                width: deviceSize.width * 0.7,
                                                child: Form(
                                                  key: _phoneFormKey,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                          height: deviceSize
                                                                  .height *
                                                              0.04),
                                                      Image.asset(
                                                        'assets/images/others/walletis_logo_png.png',
                                                        width:
                                                            deviceSize.height *
                                                                0.06,
                                                        // height: deviceSize.height * 0.07,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                      SizedBox(
                                                          height: deviceSize
                                                                  .height *
                                                              0.02),
                                                      Text(
                                                        'Enter your Phone number',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: theme
                                                              .primaryColor,
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        'to continue to Walletis',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: theme
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: deviceSize
                                                                  .height *
                                                              0.02),
                                                      TextFormField(
                                                        key: const ValueKey(
                                                            'number'),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .red.shade900,
                                                          fontSize: 18,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          fillColor: Colors
                                                              .grey.shade200,
                                                          filled: true,
                                                          isDense: true,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.phone),
                                                          prefix: Text(
                                                            '+243',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .red.shade900,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          hintStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                          hintText:
                                                              '  Enter your phone number :',
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Enter the valid number';
                                                          }
                                                          if (value.length !=
                                                              9) {
                                                            return 'This is number is too loong or too short.';
                                                          }
                                                          return null;
                                                        },
                                                        onFieldSubmitted:
                                                            (value) {
                                                          _authData['phone'] =
                                                              value.trim();
                                                        },
                                                        onChanged: (value) {
                                                          _authData['phone'] =
                                                              value.trim();
                                                        },
                                                        onSaved: (value) =>
                                                            _authData['phone'] =
                                                                value!.trim(),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      const Divider(),
                                                      const Text(
                                                        'To continue, Walletis will send you a code OTP via sms, then fill in the code after getting it',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton.icon(
                                                  icon: const Icon(
                                                      Icons.arrow_forward),
                                                  onPressed: () async {
                                                    if (!_phoneFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                  },
                                                  label: const Text(
                                                    'Get the code',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );

                                          _isPhoneLoading = true;
                                        });
                                      },
                                      icon:
                                          const Icon(CupertinoIcons.phone_fill),
                                      label: const Text('Phone'),
                                    ),
                            ),
                          ],
                        ),
                      SizedBox(height: deviceSize.height * 0.02),
                      Center(
                        child: GestureDetector(
                          onTap: _switchAuthMode,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _authMode == AuthMode.login
                                      ? 'Not a member ? '
                                      : 'Already a member ? ',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: _authMode == AuthMode.login
                                      ? 'Signup Now'
                                      : 'Login Now',
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontFamily: 'Poppins',
                                  ),
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
            ),
          ],
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
      key: const ValueKey('password'),
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900),
      decoration: InputDecoration(
        hintText: 'Enter your Password :',
        prefixIcon: const Icon(Icons.lock_open),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: isHidden
              ? const Icon(Icons.visibility_off_outlined)
              : const Icon(Icons.visibility_outlined),
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
        return null;
      },
      onSaved: (value) {
        widget._authData['password'] = value!.trim();
      },
    );
  }
}
