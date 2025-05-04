import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
         accent: const Color.fromARGB(255, 194, 166, 249),
        backButton: false,
        onDateChanged: (date) {
          setState(() {
            selectedDate = date;
          });
        },
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      ),
      body: Center(
        child:
         Row (


        ),
      ),
    );
  }
}
