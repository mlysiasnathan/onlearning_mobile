import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    var _isLoading = false;
    return ListTile(
      title: Text(widget.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName,
                  arguments: widget.id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .removeProduct(widget.id);
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Fail to Delete'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
          ),
        ]),
      ),
    );
  }
}
