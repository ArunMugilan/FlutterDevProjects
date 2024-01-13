import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/themes/ColourThemes.dart';

import 'Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  var _selectedUserType = 'user';
  var _isRegistering = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = true;
      });
      _formKey.currentState!.save();

      // Perform registration logic here, e.g., send data to a server
      final url = Uri.https(
          'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
          'user-register.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': _enteredEmail,
            'username': _enteredUsername,
            'password': _enteredPassword,
            'userType': _selectedUserType,
          },
        ),
      );

      print(response.body);
      print(response.statusCode);

      // Handle response as needed

      // Reset the form
      _formKey.currentState!.reset();

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c1,
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: c1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '  Email',
                    filled: true,
                    fillColor: c5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Add email validation logic if needed
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '  Username',
                    filled: true,
                    fillColor: c5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredUsername = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: c5,
                    labelText: '  Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  color: c5,
                  child: DropdownButtonFormField(
                    value: _selectedUserType,
                    items: const [
                      DropdownMenuItem(
                        value: 'user',
                        child: const Text('User'),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: const Text('Admin'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isRegistering
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: Text('Reset', style: TextStyle(color: c5),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: c5),
                      onPressed: _isRegistering ? null : _registerUser,
                      child: _isRegistering
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text('Register', style: TextStyle(color: c1),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
