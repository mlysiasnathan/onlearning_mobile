import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/providers.dart';
import '../models/models.dart';

class Auth with ChangeNotifier {
  User user = User(
    userId: 0,
    userName: 'Student',
    userEmail: 'unkown@test.com',
    image: 'assets/images/unknown.JPG',
  );
  String? _token;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {
          'email': email,
          'password': password,
        },
      );
      switch (response.statusCode) {
        case 200:
          user = User.fromJson(jsonDecode(response.body));
          _token = jsonDecode(response.body)['token'];
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({'token': _token});
          prefs.setString('userData', userData);
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          throw (errors[errors.keys.elementAt(0)][0]);
        case 403:
          throw (jsonDecode(response.body)['message']);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(String userName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Accept': 'application/json'},
        body: {
          'username_reg': userName,
          'email_reg': email,
          'password_reg': password,
          'password_confirmation': password,
        },
      );
      switch (response.statusCode) {
        case 200:
          user = User.fromJson(jsonDecode(response.body));
          _token = jsonDecode(response.body)['token'];
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({'token': _token});
          prefs.setString('userData', userData);
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          throw (errors[errors.keys.elementAt(0)][0]);
        case 403:
          throw (jsonDecode(response.body)['message']);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getUserDetail() async {
    try {
      final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      switch (response.statusCode) {
        case 200:
          user = User.fromJson(jsonDecode(response.body));
          break;
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json
        .decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    _token = extractedUserData['token'].toString();
    notifyListeners();
    return true;
  }

  Future<void> updateUserProfile(
      String userName, String email, String password, File image) async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
        'Content-Type': 'multipart/form-data',
      };
      final uri = Uri.parse(userURL);
      var request = http.MultipartRequest('POST', uri);
      var multipartFileSign = http.MultipartFile('profil_img', stream, length,
          filename: image.path);
      request.headers.addAll(headers);
      request.fields['username_update'] = userName;
      request.fields['email_update'] = email;
      request.fields['password_update'] = password;
      request.fields['password_confirmation_update'] = password;
      request.files.add(multipartFileSign);
      final response = await request.send();
      final res = await http.Response.fromStream(response);
      switch (response.statusCode) {
        case 200:
          user = User.fromJson(jsonDecode(res.body));
          final message = jsonDecode(res.body)['message'];
          break;
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.remove('userData');
    await pref.clear();
    notifyListeners();
  }
}
