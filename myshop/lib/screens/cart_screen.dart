import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Total',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Consumer<Cart>(
                      builder: (_, cart, __) => Text(
                        '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final cart = Provider.of<Cart>(context, listen: false);
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalPrice,
                      );
                      cart.clear();
                    },
                    child: const Text('ORDER NOW'),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Consumer<Cart>(
              builder: (_, cart, __) => ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, idx) => CartItem(
                  id: cart.items.values.toList()[idx].id,
                  productId: cart.items.keys.toList()[idx],
                  title: cart.items.values.toList()[idx].title,
                  price: cart.items.values.toList()[idx].price,
                  quantity: cart.items.values.toList()[idx].quantity,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
