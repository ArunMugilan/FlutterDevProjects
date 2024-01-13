import 'package:flutter/material.dart';
import 'package:smart_parking/screens/Welcome.dart';
import 'package:smart_parking/screens/Dashboard.dart';
import 'package:smart_parking/screens/EditProfile.dart';
import 'package:smart_parking/screens/Login.dart';
import 'package:smart_parking/screens/Register.dart';

import 'models/users.dart';

void main() async {
  final User user;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final User user;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        //'/edit': (context) => EditProfileScreen(user: user),
      },
      debugShowCheckedModeBanner: false,
      title: 'Smart Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: WelcomeScreen(),
    );
  }
}
