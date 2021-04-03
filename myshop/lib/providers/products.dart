import 'package:flutter/material.dart';

import './product.dart';
import '../dummy_data.dart';
import '../models/product_form.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteitems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  void addProduct(ProductForm newProductForm) {
    _items.add(
      Product(
        id: DateTime.now().toString(),
        title: newProductForm.title,
        price: newProductForm.price,
        description: newProductForm.description,
        imageUrl: newProductForm.imageUrl,
      ),
    );
    notifyListeners();
  }

  void editProduct(String id, ProductForm updatedProductForm) {
    final productId = items.indexWhere((product) => product.id == id);
    if (productId < 0) return;

    _items[productId] = Product(
      id: id,
      title: updatedProductForm.title,
      description: updatedProductForm.description,
      price: updatedProductForm.price,
      imageUrl: updatedProductForm.imageUrl,
      isFavorite: _items[productId].isFavorite,
    );

    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
