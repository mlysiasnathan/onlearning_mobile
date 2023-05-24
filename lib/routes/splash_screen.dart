import 'dart:math';

import 'package:app/models/api_response.dart';
import 'package:app/providers/users_provider.dart';
import 'package:app/routes/auth_screen.dart';
import 'package:app/routes/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/constants.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color.fromRGBO(90, 90, 243, 1),
//         child: const Center(
//           child: Icon(
//             Icons.menu_book_sharp,
//             size: 70,
//             color: Colors.white,
//           ),
//         ),
//         // child: Text('LOADING.....'),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);
    void loadingUserInfo() async {
      String token = await userData.getToken();
      if (token == '') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false);
      } else {
        ApiResponse response = await userData.gerUserDetail();
        if (response.errors == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const CategoriesScreen()),
              (route) => false);
        } else if (response.errors == unauthorized) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response.errors}'),
            ),
          );
        }
      }
    }

    if (!isLoaded) {
      loadingUserInfo();
      isLoaded = true;
    }

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
              // margin: const EdgeInsets.only(bottom: 10.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
              transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
              // ..translate(-10.0),
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
                // style: Theme.of(context).textTheme.bodyLarge,
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(90, 90, 243, 1),
                  fontWeight: FontWeight.normal,
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
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ),
        // child: Text('LOADING.....'),
      ),
    );
  }
}
