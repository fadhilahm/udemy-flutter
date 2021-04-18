import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order_item.dart';
import '../models/cart_item.dart';
import '../models/http_exception.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {'auth': authToken},
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        final currentProducts = (orderData['products'] as List<dynamic>)
            .map(
              (products) => CartItem(
                id: products['id'],
                title: products['title'],
                quantity: products['quantity'],
                price: products['price'],
              ),
            )
            .toList();

        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: currentProducts,
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Failed to fetch orders.');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
      'flutter-myshop-7d39c-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {'auth': authToken},
    );
    final currentTime = DateTime.now();
    final mappedCartProducts = cartProducts
        .map((cartProduct) => {
              'id': cartProduct.id,
              'title': cartProduct.title,
              'quantity': cartProduct.quantity,
              'price': cartProduct.price,
            })
        .toList();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': mappedCartProducts,
            'dateTime': currentTime.toIso8601String(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: currentTime,
        ),
      );
    } catch (error) {
      print(error);
      throw HttpException('Failed to add orders');
    } finally {
      notifyListeners();
    }
  }
}
