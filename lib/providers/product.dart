import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imgUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.imgUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoritesStatus(String authToken, String userId) async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'https://flutter-update.firebaseio.com/userFavorites/$userId/$id.json?$authToken');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      // final response = await http.patch(
      //   url,
      //   body: json.encode(
      //     {'isFavorite': isFavorite},
      //   ),
      // );
      if (response.statusCode >= 400) {
        isFavorite = oldState;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldState;
      notifyListeners();
    }
  }
}
