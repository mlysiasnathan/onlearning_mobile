import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/product.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../routes/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;
  //
  // const ProductItem(this.id, this.title, this.imgUrl, {Key? key})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    var _isLoading = true;
    Future<void> showPicture(String imgUrl) async {
      var url = Uri.https(imgUrl);
      try {
        await http.get(url);
        _isLoading = false;
      } catch (error) {
        print(error);
        _isLoading = true;
        rethrow;
      }
    }

    showPicture(product.imgUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              onPressed: () {
                product.toggleFavoritesStatus(
                    authData.token.toString(), authData.userId.toString());
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.deepOrange),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added to cart'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Consumer<Product>(
            builder: (context, product, _) => _isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.red,
                  ))
                :
                // FadeInImage(
                //         // placeholder: Icon(Icons.shopping_cart),
                //         image: NetworkImage(
                //           product.imgUrl,
                //         ),
                //         fit: BoxFit.cover,
                //       ),
                Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
