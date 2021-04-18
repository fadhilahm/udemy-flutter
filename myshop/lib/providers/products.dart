import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../dummy_data.dart';

import '../models/product_form.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items => [..._items];

  List<Product> get favoriteitems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> fetchAndSetProducts([bool isFilteredById = false]) async {
    var url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/products.json',
      {
        'auth': authToken,
        if (isFilteredById) ...{
          'orderBy': '\"creatorId\"',
          'equalTo': '\"$userId\"',
        }
      },
    );
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) return;

      url = Uri.https(
        'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
        '/userFavorites/$userId.json',
        {'auth': authToken},
      );
      var favoritesResponse = await http.get(url);
      var favoritesData = json.decode(favoritesResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (productId, productData) => loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: favoritesData == null
                ? false
                : favoritesData[productId] ?? false,
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
        {'auth': authToken},
      );
      final response = await http.post(
        url,
        body: json.encode({
          'title': newProductForm.title,
          'price': newProductForm.price,
          'description': newProductForm.description,
          'imageUrl': newProductForm.imageUrl,
          'creatorId': userId,
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
      {'auth': authToken},
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
      {'auth': authToken},
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
