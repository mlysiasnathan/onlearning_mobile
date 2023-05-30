import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import './providers.dart';

class Lessons with ChangeNotifier {
  final String authToken;
  Lessons(this.authToken);

  List<dynamic> courses = [];
  Lesson course = Lesson(
    lesId: 0,
    lesName: '',
    catId: 0,
    lesPrice: 0,
    lesImg: '',
    lesContent: '',
    createdAt: '',
    updatedAt: '',
  );
  Map<String, dynamic> lessonData = {};
  List<dynamic> videos = [];
  List<dynamic> documents = [];

// all courses
  Future<void> getCourses(String catName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/category/$catName'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      switch (response.statusCode) {
        case 200:
          courses = jsonDecode(response.body)['courses']
              .map((lesson) => Lesson.fromJson(lesson))
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

// all course's details
  Future<void> getCourseDetails(String catName, String lesName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/category/$catName/course/$lesName'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      switch (response.statusCode) {
        case 200:
          lessonData = jsonDecode(response.body) as Map<String, dynamic>;
          videos = lessonData['videos']
              .map((video) => Video.fromJson(video))
              .toList() as List<dynamic>;
          documents = lessonData['documents']
              .map((document) => Document.fromJson(document))
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

// // add course
//   Future<ApiResponse> addCategory(
//       String lesName, int lesPrice, String lesContent, File lesImg) async {
//     ApiResponse apiResponse = ApiResponse();
//     try {
//       final response = await http.post(
//         Uri.parse(addCategoryURL),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $authToken'
//         },
//         body: {
//           'name': lesName,
//           'price': lesPrice,
//           'description': lesContent,
//           'image': lesImg,
//         },
//       );
//       switch (response.statusCode) {
//         case 200:
//           apiResponse.data = jsonDecode(response.body);
//           break;
//         case 422:
//           final errors = jsonDecode(response.body)['errors'];
//           apiResponse.errors = errors[errors.keys.elementAt(0)][0];
//           break;
//         case 401:
//           apiResponse.errors = unauthorized;
//           break;
//         default:
//           apiResponse.errors = somethingWentWrong;
//           break;
//       }
//     } catch (error) {
//       apiResponse.errors = serverError;
//     }
//     return apiResponse;
//   }

// edit Category
// Future<ApiResponse> editCategory(
//     int catId, String catName, String catDescription, File catImg) async {
//   ApiResponse apiResponse = ApiResponse();
//   final token = await getToken();
//   try {
//     final response = await http.put(
//       Uri.parse(baseURL + '/category/$catId/update'),
//       headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
//       body: {
//         'name': catName,
//         'description': catDescription,
//         'image': catImg,
//       },
//     );
//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data = jsonDecode(response.body)['message'];
//         break;
//       case 422:
//         final errors = jsonDecode(response.body)['errors'];
//         apiResponse.errors = errors[errors.keys.elementAt(0)][0];
//         break;
//       case 401:
//         apiResponse.errors = unauthorized;
//         break;
//       default:
//         apiResponse.errors = somethingWentWrong;
//         break;
//     }
//   } catch (error) {
//     apiResponse.errors = serverError;
//   }
//   return apiResponse;
// }
//
// // delete Category
// Future<ApiResponse> deleteCategory(int catId) async {
//   ApiResponse apiResponse = ApiResponse();
//   final token = await getToken();
//   try {
//     final response = await http.delete(
//       Uri.parse(baseURL + '/category/$catId/delete'),
//       headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
//     );
//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data = jsonDecode(response.body)['message'];
//         break;
//       case 422:
//         final errors = jsonDecode(response.body)['errors'];
//         apiResponse.errors = errors[errors.keys.elementAt(0)][0];
//         break;
//       case 401:
//         apiResponse.errors = unauthorized;
//         break;
//       default:
//         apiResponse.errors = somethingWentWrong;
//         break;
//     }
//   } catch (error) {
//     apiResponse.errors = serverError;
//   }
//   return apiResponse;
// }
}
