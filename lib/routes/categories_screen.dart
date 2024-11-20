import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  static const routeName = '/categories';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final categoriesData = Provider.of<Categories>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: Card(
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                assetImages[1],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () {
          setState(() {});
        },
        child:
            const Icon(Icons.replay_circle_filled_rounded, color: Colors.white),
      ),
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          FutureBuilder(
            future: categoriesData.getAllCategories(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (dataSnapshot.error != null) {
                  Timer(Duration.zero, () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        closeIconColor: Colors.white,
                        showCloseIcon: true,
                        backgroundColor: Colors.red,
                        content: Text('${dataSnapshot.error}'),
                        duration: const Duration(seconds: 10),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  });
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'An Error was occurred !!',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                } else if (categoriesData.categories.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Category not yet published',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      (context, index) => Consumer<Categories>(
                        builder: (ctx, categoriesData, child) => CategoryItem(
                          catId: categoriesData.categories[index].catId,
                          catName: categoriesData.categories[index].catName,
                          catImg: categoriesData.categories[index].catImg,
                          catDescription:
                              categoriesData.categories[index].catDescription,
                          createdAt: categoriesData.categories[index].createdAt,
                        ),
                      ),
                      childCount: categoriesData.categories.length,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
