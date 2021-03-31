import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalPrice => _items.values
      .fold(0.0, (prev, cartItem) => prev + cartItem.price * cartItem.quantity);

  void addItem({
    @required String productId,
    @required double price,
    @required String title,
  }) {
    _items.containsKey(productId)
        ? _items.update(
            productId,
            (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
            ),
          )
        : _items.putIfAbsent(
            productId,
            () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price,
            ),
          );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1)
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    else
      _items.remove(productId);
    notifyListeners();
  }
}
