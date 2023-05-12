import 'package:flutter/material.dart';

import '../routes/lesson_screen.dart';

class LessonGetStarted extends StatelessWidget {
  final String? lesName;
  final String? lesImg;
  final String? catName;
  const LessonGetStarted({
    Key? key,
    required this.lesName,
    required this.lesImg,
    required this.catName,
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
            title: const Text(
              'Pre-requis:',
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: const [
                  Text('-You may know CSS'),
                  Text('-You may know Html'),
                  Text('-You may know Scss'),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Close',
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
