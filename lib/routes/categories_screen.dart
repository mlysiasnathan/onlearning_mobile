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
    final categoriesData = Provider.of<Categories>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
        onPressed: () {
          setState(() {});
        },
        child:
            const Icon(Icons.replay_circle_filled_rounded, color: Colors.white),
      ),
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const CustomAppBar(
            title: 'Categories',
          ),
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
