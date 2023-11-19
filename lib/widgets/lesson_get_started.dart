import 'package:flutter/material.dart';

import '../routes/screens.dart';

class LessonGetStarted extends StatelessWidget {
  final String? lesName;
  final String? lesImg;
  final String? catName;
  final List<dynamic> tags;
  const LessonGetStarted({
    Key? key,
    required this.lesName,
    required this.lesImg,
    required this.catName,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            elevation: 5,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Course requirements:'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  padding: const EdgeInsets.all(19),
                  itemCount: tags.length,
                  itemBuilder: (ctx, index) {
                    return Text(
                        '- You should know ${tags[index]['tag_name'].toUpperCase()}');
                  }),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(ctx).pushNamed(
                    LessonScreen.routeName,
                    arguments: {
                      'lesName': lesName,
                      'lesImg': lesImg,
                      'catName': catName,
                    },
                  );
                },
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Text('Get Started'),
      ),
    );
  }
}
