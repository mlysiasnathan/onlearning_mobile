import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../routes/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshProds(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(' My Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _refreshProds(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProds(context),
                      child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  itemCount: productsData.items.length,
                                  itemBuilder: (context, i) => Column(
                                    children: [
                                      UserProductItem(
                                        id: productsData.items[i].id,
                                        title: productsData.items[i].title,
                                        imageUrl: productsData.items[i].imgUrl,
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              )),
                    )),
      // RefreshIndicator(
      //   onRefresh: () => _refreshProds(context),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: ListView.builder(
      //       itemCount: productsData.items.length,
      //       itemBuilder: (context, i) => Column(
      //         children: [
      //           UserProductItem(
      //             id: productsData.items[i].id,
      //             title: productsData.items[i].title,
      //             imageUrl: productsData.items[i].imgUrl,
      //           ),
      //           const Divider(),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
