import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../dummy_data.dart';
import '../models/product_form.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteitems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/products.json',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach(
        (productId, productData) => loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        ),
      );

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductForm newProductForm) async {
    try {
      final url = Uri.https(
        'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
        '/products.json',
      );
      final response = await http.post(
        url,
        body: json.encode({
          'title': newProductForm.title,
          'price': newProductForm.price,
          'description': newProductForm.description,
          'imageUrl': newProductForm.imageUrl,
          'isFavorite': newProductForm.isFavorite,
        }),
      );
      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: newProductForm.title,
          price: newProductForm.price,
          description: newProductForm.description,
          imageUrl: newProductForm.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
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
