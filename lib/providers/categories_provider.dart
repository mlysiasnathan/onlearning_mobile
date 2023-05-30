import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import './providers.dart';

class Categories with ChangeNotifier {
  final String authToken;
  Categories(this.authToken);
  List<dynamic> categories = [];

// all Categories
  Future<void> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse(categoriesURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      switch (response.statusCode) {
        case 200:
          categories = jsonDecode(response.body)['categories']
              .map((category) => LessonCategory.fromJson(category))
              .toList() as List<dynamic>;
          break;
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// add Category
  Future<void> addCategory(
      String catName, String catDescription, File catImg) async {
    try {
      final response = await http.post(
        Uri.parse(addCategoryURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: {
          'name': catName,
          'description': catDescription,
          'image': catImg,
        },
      );
      switch (response.statusCode) {
        case 200:
          jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          throw (errors[errors.keys.elementAt(0)][0]);
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// edit Category
  Future<void> editCategory(
      int catId, String catName, String catDescription, File catImg) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/category/$catId/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: {
          'name': catName,
          'description': catDescription,
          'image': catImg,
        },
      );
      switch (response.statusCode) {
        case 200:
          jsonDecode(response.body)['message'];
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          throw (errors[errors.keys.elementAt(0)][0]);
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      // throw (serverError);
      rethrow;
    }
  }

// delete Category
  Future<void> deleteCategory(int catId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseURL/category/$catId/delete'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      switch (response.statusCode) {
        case 200:
          jsonDecode(response.body)['message'];
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          throw (errors[errors.keys.elementAt(0)][0]);
        case 401:
          throw (unauthorized);
        default:
          throw (somethingWentWrong);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
