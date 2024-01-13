import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({required this.user, Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _passwordController.text = widget.user.password;
  }

  Future<void> _updateProfile() async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app', // Replace with your actual database URL
      'user-register/${widget.user.userId}.json',
    );

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        ),
      );

      if (response.statusCode == 200) {
        // Profile updated successfully
        // You might want to navigate back or show a success message
        Navigator.pop(context);
      } else {
        // Failed to update profile
        // You can handle this case based on your requirements
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: c2,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Enter your username'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: c2,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Enter your email'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Card(
                color: c2,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Enter your new password'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: c1),
                onPressed: () {
                  _updateProfile();
                },
                child: Text('Save Changes', style: TextStyle(color: c5),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
