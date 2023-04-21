import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(prodId);
    return Scaffold(
      // appBar: AppBar(title: Text(loadedProduct.title)),
      drawer: const AppDrawer(),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(loadedProduct.title),
            background: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 19),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.desc,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 150),
          ]),
        ),
      ]
          // child: Column(
          //   children: [
          //     Container(
          //       height: 300,
          //       width: double.infinity,
          //       child: Hero(
          //         tag: loadedProduct.id,
          //         child: Image.network(
          //           loadedProduct.imgUrl,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 10),
          //     Text(
          //       '\$${loadedProduct.price}',
          //       style: const TextStyle(color: Colors.grey, fontSize: 19),
          //     ),
          //     const SizedBox(height: 10),
          //     Container(
          //       width: double.infinity,
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: Text(
          //         loadedProduct.desc,
          //         textAlign: TextAlign.center,
          //         softWrap: true,
          //       ),
          //     )
          //   ],
          // ),
          ),
    );
  }
}
