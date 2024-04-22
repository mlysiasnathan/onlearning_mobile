import 'package:app/routes/auth_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './routes/screens.dart';
import './providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Categories>(
          create: (ctx) => Categories(''),
          update: (ctx, auth, previousCategories) => Categories(
            auth.token.toString(),
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Lessons>(
          create: (ctx) => Lessons(''),
          update: (ctx, auth, previousLessons) => Lessons(
            auth.token.toString(),
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'OnLearning Mobile',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(90, 90, 243, 1),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(90, 90, 243, 1),
            ),
          ).copyWith(
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Comfortaa'),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
                elevation: 9,
                fixedSize: const Size(double.infinity, 50),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                side: const BorderSide(
                    color: Color.fromRGBO(90, 90, 243, 1), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle:
                    const TextStyle(fontSize: 19),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: TextButton.styleFrom(
                fixedSize: const Size(double.infinity, 50),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                side: const BorderSide(
                    color: Color.fromRGBO(90, 90, 243, 1), width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle:
                    const TextStyle(fontSize: 19),
              ),
            ),textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(30, 20, 106, 0.1),
              fixedSize: const Size(double.infinity, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
            primaryColor: const Color.fromRGBO(90, 90, 243, 1),
          ),
          home: auth.isAuth
              ? FutureBuilder(
                  future: auth.getUserDetail(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const CategoriesScreen(),
                )
              : FutureBuilder(
                  future: auth.tryAutologin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen2(),
                ),
          // : const AuthScreen(),
          routes: {
            AuthScreen2.routeName: (ctx) => const AuthScreen2(),
            CategoriesScreen.routeName: (ctx) => const CategoriesScreen(),
            CategoryDetailsScreen.routeName: (ctx) =>
                const CategoryDetailsScreen(),
            LessonScreen.routeName: (ctx) => const LessonScreen(),
            DocumentViewerScreen.routeName: (ctx) =>
                const DocumentViewerScreen(),
            EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
          },
        ),
      ),
    );
  }
}
