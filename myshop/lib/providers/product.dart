import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleIsFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/products/$id.json',
    );
    await http
        .patch(url, body: json.encode({'isFavorite': isFavorite}))
        .then((response) {
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException('Failed to delete isFavorite!');
      }
    });
  }
}
