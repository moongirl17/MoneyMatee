import 'package:flutter/material.dart';
import 'package:moneymate/pages/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyMate',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 37, 39, 52),
        appBarTheme: AppBarTheme(
          // backgroundColor: Color.fromARGB(255, 194, 166, 249),
           backgroundColor: Color.fromARGB(255, 55, 57, 74),
          foregroundColor:  Color.fromARGB(255, 217, 203, 244),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
      home: const Home(),
    );
  }
}