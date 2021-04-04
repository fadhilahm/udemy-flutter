import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './orders_screen.dart';

import '../widgets/cart_item.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
                  Consumer<Cart>(
                    builder: (ctx, cart, child) => TextButton(
                      onPressed: cart.items.isEmpty
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              try {
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addOrder(
                                  cart.items.values.toList(),
                                  cart.totalPrice,
                                );
                                cart.clear();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    OrdersScreen.routeName, (route) => false);
                              } catch (_) {
                                scaffoldMessenger.showSnackBar(SnackBar(
                                  content: const Text(
                                    'Error adding order!',
                                    textAlign: TextAlign.center,
                                  ),
                                ));
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )
                          : const Text('ORDER NOW'),
                    ),
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
