import 'dart:convert';

import 'package:flutter/material.dart';
import 'Register.dart';
import 'Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<User> newUser = [];
  

  void _loginUser() async {
    newUser = [];
    final url = Uri.https(
        "smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app",
        'user-register.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> usersJson = json.decode(response.body);
        print(
            "#Debug login_page.dart -> valus for users = ${usersJson.values}");

        for (final tempUsers in usersJson.entries) {
          newUser.add(
            User(
                userId: tempUsers.key.toString(),
                username: tempUsers.value['username'].toString(),
                email: tempUsers.value['email'].toString(),
                password: tempUsers.value['password'].toString(),
                usertype: tempUsers.value['userType'].toString()),
          );
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error login_page.dart loading items: $error');
    }
    User? loggedUser;
    bool checkLogin = false;

    for (final tempUser in newUser) {
      if (tempUser.username == _usernameController.text &&
          tempUser.password == _passwordController.text) {
        print("#Debug login_page.dart -> User found in the database");
        loggedUser = tempUser;
        checkLogin = true;
        break;
      }
    }
    if (checkLogin && loggedUser != null) {
      // Navigate to the dashboard screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            user: loggedUser!,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incorrect username or password'),
          content: const Text('User not found.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: c5,
              ),
              child: Text(
                'Register',
                style: TextStyle(color: c1),
              ),
            ),
          ],
        ),
      );
      print("#Debug login_page.dart -> User is not in the database");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: c1),
        ),
        centerTitle: true,
        backgroundColor: c5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('images/54065.jpg'),
            Text(
              "Smart Parking App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: c1,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                hintText: "Enter your username",
                prefixIcon: const Icon(Icons.person, size: 30),
                hintStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                filled: true,
                fillColor: c5,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.password, size: 30),
                hintStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                filled: true,
                fillColor: c5,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _loginUser();
              },
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: c5,
                  padding: const EdgeInsets.only(left: 50, right: 50)),
              child: Text(
                'Login',
                style: TextStyle(color: c1),
              ),
            ),
            const SizedBox(height: 6),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New for this app? Sign up here.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: c5,
                      ),
                      child: Icon(
                        Icons.accessibility_outlined,
                        color: c1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'Dashboard.dart';
// import 'auth_service.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   void _loginUser() async {
//     String username = _usernameController.text;
//     String password = _passwordController.text;
//
//     bool loginResult = await _authService.loginUser(username, password);
//
//     if (loginResult) {
//       // Navigate to the dashboard screen after successful login
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
//     } else {
//       // Show an error message
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Login Error'),
//           content: Text('Invalid username or password. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _loginUser,
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
