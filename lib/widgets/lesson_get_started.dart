import 'package:flutter/material.dart';

class LessonGetStarted extends StatelessWidget {
  const LessonGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
      ),
      onPressed: () {
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
              TextButton(
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
                },
                child: const Text(
                  'Start',
                ),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.expand_more),
      label: const Text('Get Started'),
    );
  }
}
