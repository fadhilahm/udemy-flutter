import 'package:flutter/material.dart';

import './product.dart';
import '../dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteitems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  void addProduct() {
    notifyListeners();
  }
}
