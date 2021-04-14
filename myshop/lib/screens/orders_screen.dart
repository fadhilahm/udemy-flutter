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
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    print("Building orders widget...");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrders,
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return const Center(
                child: Text("An Error Occured..."),
              );
            }
            return Consumer<Orders>(
              builder: (_, orders, __) => ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
              ),
            );
          },
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
