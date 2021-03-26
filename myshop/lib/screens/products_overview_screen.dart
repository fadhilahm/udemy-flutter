import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../dummy_data.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, idx) => ProductItem(
                id: loadedProducts[idx].id,
                title: loadedProducts[idx].title,
                imageUrl: loadedProducts[idx].imageUrl,
              )),
    );
  }
}
