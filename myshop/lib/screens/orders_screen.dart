import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../widgets/main_drawer.dart';

import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrders,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Orders>(
                builder: (_, orders, __) => ListView.builder(
                      itemCount: orders.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
                    )),
      ),
      drawer: MainDrawer(),
    );
  }
}
