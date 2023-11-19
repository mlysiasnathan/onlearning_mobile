import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({Key? key}) : super(key: key);
  static const routeName = '/lesson';

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    final lesInfo =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;

    final catName = lesInfo['catName'];
    final lesName = lesInfo['lesName'];
    final lesImg = lesInfo['lesImg'];

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
            title: 'Lesson ${lesName!.toUpperCase()}',
            image: lesImg,
          ),
          FutureBuilder(
            future: coursesData.getCourseDetails(catName!, lesName),
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
                } else {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      [
                        Consumer<Lessons>(
                          builder: (ctx, coursesData, child) => coursesData
                                  .documents.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: Center(
                                    child: Text(
                                      'Document not yet published',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Center(
                                    child: Text(
                                      'Documents to download',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                        ),
                        Consumer<Lessons>(
                          builder: (ctx, coursesData, child) => coursesData
                                  .documents.isNotEmpty
                              ? SizedBox(
                                  // height: 60,
                                  height: min(
                                      coursesData.documents.length * 19.0 + 10,
                                      100),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(10),
                                    // physics: const NeverScrollableScrollPhysics(),
                                    itemCount: coursesData.documents.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(1.9),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            DocumentViewerScreen.routeName,
                                            arguments:
                                                '$assetsURL/storage/${coursesData.documents[index].pdfFile}',
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons
                                                .my_library_books_outlined),
                                            Text(
                                                '${coursesData.documents[index].pdfId}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Consumer<Lessons>(
                          builder: (ctx, coursesData, child) => coursesData
                                  .videos.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: Center(
                                    child: Text(
                                      'Video not yet published',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Table of contents & Videos',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                        ),
                        Consumer<Lessons>(
                          builder: (ctx, coursesData, child) => coursesData
                                  .videos.isNotEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: coursesData.videos.length,
                                    itemBuilder: (context, index) => VideoItem(
                                        vidName:
                                            coursesData.videos[index].vidName,
                                        vidFile:
                                            coursesData.videos[index].vidFile),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
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
