import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './routes/auth_screen_2.dart';
import './routes/on_boarding_screen.dart';
import './routes/proxy_screen.dart';
import './routes/screens.dart';
import './providers/providers.dart';
import 'helpers/helpers.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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
      child: MaterialApp(
        title: 'OnLearning Mobile',
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        // home: const ProxyScreen(),
        home: Consumer<Auth>(
          builder: (ctx, auth, _) => FutureBuilder(
            future: auth.showOnBoardingPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              } else if (!auth.appInitialized) {
                return const OnBoardingScreen();
              }
              return auth.isAuth
                  ? FutureBuilder(
                      future: auth.getUserDetail(),
                      builder: (ctx, authSnapshot) =>
                          !authSnapshot.hasData || authSnapshot.hasError
                              ? const ProxyScreen()
                              : authSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const SplashScreen()
                                  : const CategoriesScreen(),
                    )
                  : FutureBuilder(
                      future: auth.tryAutologin(),
                      builder: (ctx, authSnapshot) =>
                          authSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen2(),
                    );
            },
          ),
        ),
        routes: {
          AuthScreen2.routeName: (ctx) => const AuthScreen2(),
          CategoriesScreen.routeName: (ctx) => const CategoriesScreen(),
          CategoryDetailsScreen.routeName: (ctx) =>
              const CategoryDetailsScreen(),
          LessonScreen.routeName: (ctx) => const LessonScreen(),
          DocumentViewerScreen.routeName: (ctx) => const DocumentViewerScreen(),
          EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
        },
      ),
    );
  }
}
