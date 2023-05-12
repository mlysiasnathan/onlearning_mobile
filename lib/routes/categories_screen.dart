import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../providers/categories_services.dart';
import '../providers/constants.dart';
import '../providers/user_services.dart';
import '../widgets/category_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';
import './auth_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  static const routeName = '/categories';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> categories = [];
  bool _isLoading = true;
  Future<void> retrieveCategories() async {
    ApiResponse response = await getAllCategories();
    if (response.errors == null) {
      setState(() {
        categories = response.data as List<dynamic>;
        _isLoading = !_isLoading;
      });
    } else if (response.errors == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AuthScreen(),
              ),
              (route) => false)
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('${response.errors}'),
        ),
      );
    }
  }

  @override
  void initState() {
    retrieveCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
        onPressed: () {
          retrieveCategories();
          setState(() {
            _isLoading = !_isLoading;
          });
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
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : categories.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Category not yet published',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => CategoryItem(
                          catId: categories[index].catId,
                          catName: categories[index].catName,
                          catImg: categories[index].catImg,
                          catDescription: categories[index].catDescription,
                          createdAt: categories[index].createdAt,
                        ),
                        childCount: categories.length,
                      ),
                    ),
        ],
      ),
    );
  }
}
