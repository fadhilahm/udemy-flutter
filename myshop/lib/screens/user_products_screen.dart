import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/user_product_item.dart';
import '../widgets/main_drawer.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<Products>(
          builder: (context, products, child) => ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (ctx, i) => UserProductItem(
              products.items[i].title,
              products.items[i].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
