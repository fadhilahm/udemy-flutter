import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/main_drawer.dart';
import '../providers/cart.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _areFavoritesShown = false;

  void selectPopUp(FilterOptions filter) =>
      setState(() => _areFavoritesShown = filter == FilterOptions.Favorites);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: selectPopUp,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: ProductsGrid(_areFavoritesShown),
    );
  }
}
