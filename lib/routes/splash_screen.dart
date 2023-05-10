// import 'dart:html';

import 'dart:math';

import 'package:app/models/api_response.dart';
import 'package:app/providers/user_services.dart';
import 'package:app/routes/auth_screen.dart';
import 'package:app/routes/categories_screen.dart';
// import 'package:app/routes/products_overview_screen.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
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
  void _loadingUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false);
    } else {
      ApiResponse response = await gerUserDetail();
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

  @override
  void initState() {
    _loadingUserInfo();
    print('try login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(90, 90, 243, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.menu_book_sharp,
              size: 70,
              color: Colors.white,
            ),
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
