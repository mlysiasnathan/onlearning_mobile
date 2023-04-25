import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../providers/constants.dart';
import '../providers/lesson_services.dart';
import '../providers/user_services.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/lesson_item.dart';
import 'auth_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({Key? key}) : super(key: key);
  static const routeName = '/lesson';

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<dynamic> lessonData = [];
  bool _isLoading = true;
  bool isLoaded = false;

  Future<void> retrieveCourseAttachments(String catName, String lesName) async {
    ApiResponse response = await getCourseDetails(catName, lesName);
    if (response.errors == null) {
      setState(() {
        lessonData = response.data as List<dynamic>;
        print(lessonData);
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
          dismissDirection: DismissDirection.up,
          backgroundColor: Colors.red,
          content: Text('${response.errors}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final catName = lesInfo['catName'];
    final lesName = lesInfo['lesName'];
    final lesImg = lesInfo['lesImg'];
    if (!isLoaded) {
      retrieveCourseAttachments(catName!, lesName!);
      isLoaded = true;
    }
    // retrieveCourses(catName);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
        onPressed: () {
          setState(() {
            // retrieveCourses(catName);
            isLoaded = false;
            _isLoading = !_isLoading;
          });
        },
        child: const Icon(Icons.replay_circle_filled_rounded),
      ),
      endDrawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          CustomAppBar(
              title: 'Lesson ${lesName!.toUpperCase()}', image: lesImg),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : lessonData.isEmpty
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
                          lesId: lessonData[index].lesId,
                          lesName: lessonData[index].lesName,
                          lesImg: lessonData[index].lesImg,
                          lesContent: lessonData[index].lesContent,
                          lesPrice: lessonData[index].lesPrice,
                          createdAt: lessonData[index].createdAt,
                          catName: catName,
                        ),
                        childCount: lessonData.length,
                      ),
                    ),
        ],
      ),
    );
  }
}
