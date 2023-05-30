import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/category-details';

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final catInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final catName = catInfo['catName'];
    final catImg = catInfo['catImg'];
    final coursesData = Provider.of<Lessons>(context, listen: false);
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
          CustomAppBar(
            title: 'Category ${catName!.toUpperCase()}',
            image: catImg,
          ),
          FutureBuilder(
            future: coursesData.getCourses(catName),
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
                } else if (coursesData.courses.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Course not yet published',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Consumer<Lessons>(
                          builder: (ctx, coursesData, child) {
                            return LessonItem(
                              lesId: coursesData.courses[index].lesId,
                              lesName: coursesData.courses[index].lesName,
                              lesImg: coursesData.courses[index].lesImg,
                              lesContent: coursesData.courses[index].lesContent,
                              lesPrice: coursesData.courses[index].lesPrice,
                              createdAt: coursesData.courses[index].createdAt,
                              catName: catName,
                            );
                          },
                        );
                      },
                      childCount: coursesData.courses.length,
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
