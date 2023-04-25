import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/lesson_category.dart';
import '../models/api_response.dart';
import './user_services.dart';
import './constants.dart';

// all Categories
Future<ApiResponse> getAllCategories() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final token = await getToken();

    final response = await http.get(
      Uri.parse(categoriesURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['categories']
            .map((category) => LessonCategory.fromJson(category))
            .toList() as List<dynamic>;
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

// add Category
Future<ApiResponse> addCategory(
    String catName, String catDescription, File catImg) async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.post(
      Uri.parse(addCategoryURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'name': catName,
        'description': catDescription,
        'image': catImg,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors = errors[errors.keys.elementAt(0)][0];
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

// edit Category
Future<ApiResponse> editCategory(
    int catId, String catName, String catDescription, File catImg) async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.put(
      Uri.parse(baseURL + '/category/$catId/update'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'name': catName,
        'description': catDescription,
        'image': catImg,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors = errors[errors.keys.elementAt(0)][0];
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

// delete Category
Future<ApiResponse> deleteCategory(int catId) async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.delete(
      Uri.parse(baseURL + '/category/$catId/delete'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors = errors[errors.keys.elementAt(0)][0];
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
