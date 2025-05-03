import 'package:flutter/material.dart';

// Tema terang
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color.fromARGB(255, 194, 166, 249),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

// Tema gelap
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 37, 39, 52),
  primaryColor: const Color.fromARGB(255, 194, 166, 249),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
