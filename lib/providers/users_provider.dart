import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';

class Users with ChangeNotifier {
  late User user;

  Future<ApiResponse> login(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();
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
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          user = apiResponse.data as User;
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.errors = errors[errors.keys.elementAt(0)][0];
          break;
        case 403:
          apiResponse.errors = jsonDecode(response.body)['message'];
          break;
        default:
          apiResponse.errors = somethingWentWrong;
          break;
      }
    } catch (error) {
      apiResponse.errors = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> register(
      String userName, String email, String password) async {
    ApiResponse apiResponse = ApiResponse();
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
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          user = apiResponse.data as User;
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.errors = errors[errors.keys.elementAt(0)][0];
          break;
        default:
          apiResponse.errors = somethingWentWrong;
          break;
      }
    } catch (error) {
      apiResponse.errors = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> gerUserDetail() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      switch (response.statusCode) {
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          user = apiResponse.data as User;
          break;
        case 401:
          apiResponse.errors = unauthorized;
          break;
        default:
          apiResponse.errors = somethingWentWrong;
          break;
      }
    } catch (error) {
      apiResponse.errors = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> updateUserProfile(
      String userName, String email, String password, File image) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final token = await getToken();
      var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
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
          apiResponse.data = jsonDecode(res.body)['message'];
          print(request.fields);
          break;
        case 401:
          apiResponse.errors = unauthorized;
          break;
        default:
          apiResponse.errors = somethingWentWrong;
          break;
      }
    } catch (error) {
      apiResponse.errors = serverError;
    }
    return apiResponse;
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id') ?? 0;
  }

  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.remove('token');
  }
}
