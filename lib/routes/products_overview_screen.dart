import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart' as bdg;
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOpt {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  const ProductsOverViewScreen({Key? key}) : super(key: key);
  static const routeName = '/products-overView';

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).items;
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final prodData = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Nice Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, childd) => bdg.Badge(
              value: cart.itemCount.toString(),
              child: childd as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOpt value) {
              setState(() {
                if (value == FilterOpt.Favorites) {
                  _showOnlyFavorite = true;
                  // prodData.showFavorites();
                } else {
                  _showOnlyFavorite = false;
                  // prodData.showAll();
                }
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: FilterOpt.Favorites,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: FilterOpt.All,
                child: Text('All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(_showOnlyFavorite),

      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     const SizedBox(height: 5),
      //     Container(
      //         child: _isLoading
      //             ? const LinearProgressIndicator()
      //             : const SizedBox()),
      //     ProductsGrid(_showOnlyFavorite),
      //   ],
      // ),
    );
  }
}
