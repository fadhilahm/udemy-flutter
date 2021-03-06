import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/user_product_item.dart';
import '../widgets/main_drawer.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async =>
      Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);

  @override
  Widget build(BuildContext context) {
    print('build user_products_screen.dart...');
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
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Consumer<Products>(
                      builder: (context, products, child) => ListView.builder(
                        itemCount: products.items.length,
                        itemBuilder: (ctx, i) => UserProductItem(
                          id: products.items[i].id,
                          title: products.items[i].title,
                          imageUrl: products.items[i].imageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
