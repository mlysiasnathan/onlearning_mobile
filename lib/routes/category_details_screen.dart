import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api_response.dart';
import '../providers/users_provider.dart';
import '../providers/lessons_provider.dart';
import '../providers/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/lesson_item.dart';
import './auth_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/category-details';

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  List<dynamic> courses = [];
  bool _isLoading = true;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final catInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final catName = catInfo['catName'];
    final catImg = catInfo['catImg'];
    final userData = Provider.of<Users>(context);
    final coursesData = Provider.of<Lessons>(context);
    Future<void> retrieveCourses(String catName) async {
      ApiResponse response = await coursesData.getCourses(catName);
      if (response.errors == null) {
        setState(() {
          courses = response.data as List<dynamic>;
          _isLoading = !_isLoading;
        });
      } else if (response.errors == unauthorized) {
        userData.logout().then(
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
            dismissDirection: DismissDirection.up,
            backgroundColor: Colors.red,
            content: Text('${response.errors}'),
          ),
        );
      }
    }

    if (!isLoaded) {
      retrieveCourses(catName!);
      isLoaded = true;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
        onPressed: () {
          setState(() {
            isLoaded = false;
            _isLoading = !_isLoading;
          });
        },
        child:
            const Icon(Icons.replay_circle_filled_rounded, color: Colors.white),
      ),
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          CustomAppBar(
              title: 'Category ${catName!.toUpperCase()}', image: catImg),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : courses.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Course not yet published',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => LessonItem(
                          lesId: courses[index].lesId,
                          lesName: courses[index].lesName,
                          lesImg: courses[index].lesImg,
                          lesContent: courses[index].lesContent,
                          lesPrice: courses[index].lesPrice,
                          createdAt: courses[index].createdAt,
                          catName: catName,
                        ),
                        childCount: courses.length,
                      ),
                    ),
        ],
      ),
    );
  }
}
