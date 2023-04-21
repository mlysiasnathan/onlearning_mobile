import 'package:app/models/api_response.dart';
import 'package:app/providers/categories_services.dart';
import 'package:app/providers/constants.dart';
import 'package:app/providers/user_services.dart';
import 'package:flutter/material.dart';

import '../widgets/category_item.dart';
import './auth_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> categories = [];
  int userId = 0;
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
        child: const Icon(Icons.replay_circle_filled_rounded),
      ),
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const CustomAppBar(),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CategoryItem(
                      catId: categories[index].catId,
                      catName: categories[index].catName,
                      catImg: categories[index].catImg,
                      catDescription: categories[index].catDescription,
                    ),
                    childCount: categories.length,
                  ),
                ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 7,
      shadowColor: const Color.fromRGBO(90, 90, 243, 1),
      backgroundColor: const Color.fromRGBO(241, 241, 241, 0.9450980392156862),
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 130.0,
      centerTitle: true,
      actions: [
        // IconButton(
        //   onPressed: () {
        //     action;
        //   },
        //   icon: const Icon(Icons.refresh, color: Colors.blue),
        // ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Color.fromRGBO(90, 90, 243, 1),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'Home & Categories',
          style: TextStyle(
            color: Color.fromRGBO(90, 90, 243, 1),
          ),
        ),
        background: Image.network(
          '${assetsURL}/img/line.jpg',
          fit: BoxFit.cover,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: CircleAvatar(
            backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
            child: Image.network(
              '${assetsURL}/img/apple-touch-icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            accountEmail: Text('user.name@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: FlutterLogo(size: 42.0),
            ),
          ),
          ListTile(
            title: const Text('Edit profil'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Current course'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              logout().then(
                (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                    (route) => false),
              );
            },
          ),
        ],
      ),
    );
  }
}
