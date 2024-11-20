import 'dart:math';

import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: theme.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 70.0),
              transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: theme.colorScheme.shadow,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                'Onlearning',
                style: TextStyle(
                  fontSize: 30,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 25,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  assetImages[1],
                  width: mediaQuery.height * 0.20,
                  height: mediaQuery.height * 0.20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'From',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.background,
                    fontSize: 12,
                    letterSpacing: 4.0,
                  ),
                ),
                Image.asset(
                  assetImages[0],
                  width: mediaQuery.width * 0.3,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  backgroundColor: theme.primaryColor,
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(30),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
