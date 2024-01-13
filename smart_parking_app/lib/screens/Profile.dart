import 'package:smart_parking/themes/ColourThemes.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/screens/Complaint.dart';

import 'EditProfile.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  // final bool isAdmin = true; // check user is admin. create a method
  // final bool hideReviewnReply = false;

  ProfilePage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: c3,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: c1,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: widget.user),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: c1,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_rounded,
                size: 60,
              ),
              const Text(
                "Account Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                color: c2,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.email,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.usertype,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: widget.user)),
                        ),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: c3),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: c1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'If you have any complaint, do let us know',
                style: TextStyle(color: Colors.black),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComplaintPage()),
                ),
                style: OutlinedButton.styleFrom(backgroundColor: c2),
                child: Text(
                  'Complaints',
                  style: TextStyle(color: c1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
