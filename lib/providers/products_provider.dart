// import 'dart:convert';
//
// import 'package:app/models/http_exceptions.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import './product.dart';
//
// class Products with ChangeNotifier {
//   String authToken = '1';
//   String userId = 'dsfdsfsfds';
//
//   Products(this.authToken, this.userId, this._items);
//   List<Product> _items = [
//     Product(
//       id: 'p1',
//       title: 'Red Shirt',
//       desc: 'A red shirt - it is pretty red!',
//       price: 29.99,
//       imgUrl:
//           'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//     ),
//     Product(
//       id: 'p2',
//       title: 'Trousers',
//       desc: 'A nice pair of trousers.',
//       price: 59.99,
//       imgUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//     ),
//     Product(
//       id: 'p3',
//       title: 'Yellow Scarf',
//       desc: 'Warm and cozy - exactly what you need for the winter.',
//       price: 19.99,
//       imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//     ),
//     Product(
//       id: 'p4',
//       title: 'A Pan',
//       desc: 'Prepare any meal you want.',
//       price: 49.99,
//       imgUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//     ),
//     Product(
//       id: 'p5',
//       title: 'Trousers soft',
//       desc: 'A nice pair of trousers.',
//       price: 59.99,
//       imgUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//     ),
//     Product(
//       id: 'p6',
//       title: 'A new Pan',
//       desc: 'Prepare any meal you want.',
//       price: 49.99,
//       imgUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//     ),
//     Product(
//       id: 'p7',
//       title: 'Yellow new Scarf',
//       desc: 'Warm and cozy - exactly what you need for the winter.',
//       price: 19.99,
//       imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//     ),
//   ];
//   // var _showFavoritesOnly = false;
//   List<Product> get favoriesItems {
//     // notifyListeners();
//     return _items.where((prodItem) => prodItem.isFavorite).toList();
//   }
//
//   List<Product> get items {
//     // if (_showFavoritesOnly) {
//     //   return _items.where((prodItem) => prodItem.isFavorite).toList();
//     // }
//     return [..._items];
//   }
//
//   Product findById(String id) {
//     return _items.firstWhere((prod) => prod.id == id);
//   }
//
//   // void showFavorites() {
//   //   _showFavoritesOnly = true;
//   //   notifyListeners();
//   // }
//
//   // void showAll() {
//   //   _showFavoritesOnly = false;
//   //   notifyListeners();
//   // }
//
//   Future<void> addProduct(Product product) async {
//     var url =
//         Uri.https('flutter-update.firebaseio.com/products.json?aut=$authToken');
//     try {
//       final response = await http.post(
//         url,
//         body: json.encode(
//           {
//             'title': product.title,
//             'createdBy': userId,
//             'desc': product.desc,
//             'price': product.price,
//             'imgUrl': product.imgUrl,
//             // 'isFavorite': product.isFavorite,
//           },
//         ),
//       );
//       final newProduct = Product(
//         id: json.decode(response.body)['name'],
//         title: product.title,
//         desc: product.desc,
//         price: product.price,
//         imgUrl: product.imgUrl,
//       );
//       _items.add(newProduct);
//       // _items.insert(0, newProduct); //if you want your new product at the begging of the list
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }
//
//   Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
//     final filterString =
//         filterByUser ? 'orderBy="createdBy"&equalTo="$userId"' : '';
//     var url = Uri.https(
//         'https://flutter-update.firebaseio.com/products.json?aut=$authToken&$filterString');
//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       if (extractedData == null) {
//         return;
//       }
//       url = Uri.https(
//           'https://flutter-update.firebaseio.com/userFavorites/$userId.json?$authToken');
//       final favResponse = await http.get(url);
//       final favData = json.decode(favResponse.body);
//       final List<Product> fromNetProducts = [];
//       extractedData.forEach((prodId, prodData) {
//         fromNetProducts.add(
//           Product(
//             id: prodId,
//             title: prodData['title'],
//             desc: prodData['desc'],
//             price: prodData['price'],
//             imgUrl: prodData['imgUrl'],
//             isFavorite: favData == null ? false : favData['prodId'] ?? false,
//             // isFavorite: prodData['isFavorites'],
//           ),
//         );
//       });
//       _items = fromNetProducts;
//       // _items = items;
//       notifyListeners();
//     } catch (error) {
//       throw (error);
//     }
//   }
//
//   Future<void> updateProduct(String id, Product newProduct) async {
//     final prodIndex = _items.indexWhere((prod) => prod.id == id);
//     if (prodIndex >= 0) {
//       final url = Uri.https(
//           'https://flutter-update.firebaseio.com/products/$id.json?aut=$authToken');
//       //
//       try {
//         await http.patch(
//           url,
//           body: json.encode(
//             {
//               'title': newProduct.title,
//               'desc': newProduct.desc,
//               'price': newProduct.price,
//               'imgUrl': newProduct.imgUrl,
//             },
//           ),
//         );
//         _items[prodIndex] = newProduct;
//         notifyListeners();
//       } catch (error) {
//         print(error);
//         throw error;
//       }
//     }
//   }
//
//   Future<void> removeProduct(String id) async {
//     final url = Uri.https(
//         'https://flutter-update.firebaseio.com/products/$id.json?aut=$authToken');
//     final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
//     Product? existingProduct = _items[existingProdIndex];
//
//     _items.removeAt(existingProdIndex);
//     notifyListeners();
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       _items.insert(existingProdIndex, existingProduct);
//       notifyListeners();
//       throw MyPersonalHttpException('Could not delete this Product');
//     }
//     existingProduct = null;
//   }
// }
