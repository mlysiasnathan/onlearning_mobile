import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  const ProductsGrid(this.showFav, {super.key});
  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context).items;
    final loadedProducts = Provider.of<Products>(context);
    final products =
        showFav ? loadedProducts.favoriesItems : loadedProducts.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imgUrl,
            ),
      ),
      itemCount: products.length,
    );
  }
}
