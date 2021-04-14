import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../dummy_data.dart';

import '../models/product_form.dart';
import '../models/http_exception.dart';

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
      if (extractedData == null) return;

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

  Future<void> editProduct(String id, ProductForm updatedProductForm) async {
    final productId = items.indexWhere((product) => product.id == id);
    if (productId < 0) return;
    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/products/$id.json',
    );
    try {
      await http.patch(url,
          body: json.encode({
            'title': updatedProductForm.title,
            'description': updatedProductForm.description,
            'price': updatedProductForm.price,
            'imageUrl': updatedProductForm.imageUrl,
          }));

      _items[productId] = Product(
        id: id,
        title: updatedProductForm.title,
        description: updatedProductForm.description,
        price: updatedProductForm.price,
        imageUrl: updatedProductForm.imageUrl,
        isFavorite: _items[productId].isFavorite,
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    // Optimistic Update
    final existingProductIndex =
        items.indexWhere((product) => product.id == id);
    var existingProduct = items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/products/$id.json',
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Cannot delete product!');
    }

    existingProduct = null; // Delete the pointer because it is now unused.
  }
}
