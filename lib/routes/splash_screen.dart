import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(90, 90, 243, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 70.0),
              transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: const Text(
                'Onlearning',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(90, 90, 243, 1),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 19,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/onlearning_logo.jpg',
                  width: mediaQuery.height * 0.20,
                  height: mediaQuery.height * 0.20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
