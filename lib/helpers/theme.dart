import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.light,
  primaryColor: const Color.fromRGBO(90, 90, 243, 1),
  primaryColorLight: const Color.fromRGBO(144, 133, 232, 1.0),
  primaryColorDark: const Color.fromRGBO(64, 55, 133, 1.0),
  colorScheme: const ColorScheme.light(
    error: Colors.red,
    background: Colors.white,
    primary: Color.fromRGBO(90, 90, 243, 1),
    secondary: Color.fromRGBO(90, 90, 243, 1),
    shadow: Colors.black54,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(90, 90, 243, 1),
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w900,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(color: Colors.white),
    backgroundColor: Colors.white,
    closeIconColor: const Color.fromRGBO(90, 90, 243, 1),
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
      elevation: 9,
      fixedSize: const Size(double.infinity, 50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      side: const BorderSide(color: Color.fromRGBO(90, 90, 243, 1), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 19),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: TextButton.styleFrom(
      fixedSize: const Size(double.infinity, 50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      side: const BorderSide(color: Color.fromRGBO(90, 90, 243, 1), width: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: const TextStyle(fontSize: 19),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color.fromRGBO(30, 20, 106, 0.1),
      fixedSize: const Size(double.infinity, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    iconColor: Colors.white,
    prefixIconColor: Color.fromRGBO(90, 90, 243, 1),
    suffixIconColor: Color.fromRGBO(90, 90, 243, 1),
    hintStyle: TextStyle(
      color: Color.fromRGBO(90, 90, 243, 0.4),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.dark,
  primaryColor: const Color.fromRGBO(90, 90, 243, 1),
  primaryColorLight: const Color.fromRGBO(116, 105, 206, 1.0),
  primaryColorDark: const Color.fromRGBO(63, 54, 131, 1.0),
  colorScheme: const ColorScheme.dark(
    error: Color.fromRGBO(155, 25, 16, 1.0),
    background: Colors.black,
    primary: Color.fromRGBO(90, 90, 243, 1),
    secondary: Color.fromRGBO(90, 90, 243, 1),
    shadow: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(90, 90, 243, 1),
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w900,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(color: Colors.white),
    backgroundColor: Colors.black38,
    closeIconColor: const Color.fromRGBO(90, 90, 243, 1),
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
      elevation: 9,
      fixedSize: const Size(double.infinity, 50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      side: const BorderSide(color: Color.fromRGBO(90, 90, 243, 1), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 19),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: TextButton.styleFrom(
      fixedSize: const Size(double.infinity, 50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      side: const BorderSide(color: Color.fromRGBO(90, 90, 243, 1), width: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: const TextStyle(fontSize: 19),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: const Color.fromRGBO(30, 20, 106, 0.1),
      fixedSize: const Size(double.infinity, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    iconColor: Colors.white,
    prefixIconColor: Color.fromRGBO(90, 90, 243, 1),
    suffixIconColor: Color.fromRGBO(90, 90, 243, 1),
    hintStyle: TextStyle(
      color: Color.fromRGBO(90, 90, 243, 0.4),
    ),
  ),
);
