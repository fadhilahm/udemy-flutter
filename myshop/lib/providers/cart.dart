import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get items => {..._items};

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
  }
}
