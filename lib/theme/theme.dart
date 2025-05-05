import 'package:flutter/material.dart';

// Tema terang
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color.fromARGB(255, 224, 222, 222),
  primaryColor: const Color.fromARGB(255, 194, 166, 249),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 194, 166, 249), // Tetap menggunakan primary color
    foregroundColor: Colors.black, // Warna teks & icon toolbar
    iconTheme: IconThemeData(color: Colors.black), // Warna icon
  ),
  iconTheme: const IconThemeData(
    color: Colors.black, // Warna default untuk semua icon
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 37, 39, 52),
  primaryColor: const Color.fromARGB(255, 194, 166, 249),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 55, 57, 74),
    foregroundColor: Colors.white, // Warna teks & icon toolbar
    iconTheme: IconThemeData(color: Colors.white), // Warna icon
  ),
  iconTheme: const IconThemeData(
    color: Colors.white, // Warna default untuk semua icon
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.white),
    ),
  ), // <- Tanda koma di sini
);