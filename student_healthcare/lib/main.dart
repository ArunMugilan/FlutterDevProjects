import 'package:flutter/material.dart';
import 'HealthTrackingScreen.dart';
import 'StudentData.dart';
import 'MenstrualCycleTrackerScreen.dart';
import 'MenuScreen.dart';
import 'AppointmentScreen.dart';
import 'Tips&Tricks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Health App',
      home: StudentInfoScreen(),
      routes: {
        '/menu': (context) => MenuScreen(name: '', age: 0, matricsNumber: '', gender: '',),
        '/menstruationTracker': (context) => MenstruationCycleTrackerScreen(),
        '/healthTracker': (context) => HealthTrackingScreen(),
        '/tips&tricks': (context) => TipsAndTricksScreen(),
        '/appointment': (context) => AppointmentScreen(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}



