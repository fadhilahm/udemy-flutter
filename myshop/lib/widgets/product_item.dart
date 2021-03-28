import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    print('rebuild ProductItem widget');

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title),
          leading: IconButton(
            color: Theme.of(context).accentColor,
            icon: Consumer<Product>(
              builder: (ctx, product, _) => Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            onPressed: product.toggleIsFavorite,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => cart.addItem(
              productId: product.id,
              price: product.price,
              title: product.title,
            ),
          ),
        ),
      ),
    );
  }
}
