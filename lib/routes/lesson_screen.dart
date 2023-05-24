import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './document_viewer_screen.dart';
import '../models/api_response.dart';
import '../models/document.dart';
import '../models/video.dart';
import '../providers/constants.dart';
import '../providers/lessons_provider.dart';
import '../providers/users_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/video_item.dart';
import './auth_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({Key? key}) : super(key: key);
  static const routeName = '/lesson';

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Map<String, dynamic> lessonData = {};
  List<dynamic> videos = [];
  List<dynamic> documents = [];
  bool _isLoading = true;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final lesInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final userData = Provider.of<Users>(context);
    final coursesData = Provider.of<Lessons>(context);
    final catName = lesInfo['catName'];
    final lesName = lesInfo['lesName'];
    final lesImg = lesInfo['lesImg'];
    Future<void> retrieveCourseAttachments(
        String catName, String lesName) async {
      ApiResponse response =
          await coursesData.getCourseDetails(catName, lesName);
      if (response.errors == null) {
        setState(() {
          lessonData = response.data as Map<String, dynamic>;
          videos = lessonData['videos']
              .map((video) => Video.fromJson(video))
              .toList() as List<dynamic>;
          documents = lessonData['documents']
              .map((document) => Document.fromJson(document))
              .toList() as List<dynamic>;
          // course = lessonData['course'] as List<dynamic>;
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
      retrieveCourseAttachments(catName!, lesName!);
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
              title: 'Lesson ${lesName!.toUpperCase()}', image: lesImg),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SliverFillRemaining(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      documents.isEmpty
                          ? const Text(
                              'Document not yet published',
                              style: TextStyle(fontSize: 24),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Documents to download',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                      if (documents.isNotEmpty)
                        SizedBox(
                          // height: 60,
                          height: min(documents.length * 19.0 + 10, 100),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(10),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(1.9),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    DocumentViewerScreen.routeName,
                                    arguments:
                                        '$assetsURL/storage/${documents[index].pdfFile}',
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.my_library_books_outlined),
                                    Text('${documents[index].pdfId}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      videos.isEmpty
                          ? const Text(
                              'Video not yet published',
                              style: TextStyle(fontSize: 24),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Table of contents & Videos',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                      if (videos.isNotEmpty)
                        SizedBox(
                          height: 400,
                          // height: min(videos.length * 19.0 + 10, 100),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: videos.length,
                            itemBuilder: (context, index) => VideoItem(
                                vidName: videos[index].vidName,
                                vidFile: videos[index].vidFile),
                          ),
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
