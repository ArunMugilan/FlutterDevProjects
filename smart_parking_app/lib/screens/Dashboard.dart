import 'package:flutter/material.dart';
import 'package:smart_parking/models/users.dart';
import 'AddParking.dart';
import 'ManageParking.dart';
import 'ParkingSpace.dart';
import 'ManageBooking.dart';
import 'Profile.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({super.key, required this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  void initPages() {
    _pages = [
      ParkingSpacePage(user: widget.user),
      if (widget.user.usertype == 'admin')
        AddParkingPage(
          user: widget.user,
        ),
      if (widget.user.usertype != 'admin')
        ManageBooking(
          user: widget.user,
        ),
      if (widget.user.usertype == 'admin')
        ManageParking(),
      ProfilePage(
        user: widget.user,
      ),
    ];
  }

  @override
  void initState() {
    initPages();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Parking Dashboard',
          style: TextStyle(color: c1),
        ),
        backgroundColor: c2,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: c2,
        unselectedItemColor: c1,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Parking Space',
          ),
          if (widget.user.usertype == 'admin')
            const BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Parking',
            ),
          if (widget.user.usertype == 'admin')
            const BottomNavigationBarItem(
              icon: Icon(Icons.edit_note),
              label: 'Manage Parking',
            ),
          if (widget.user.usertype != 'admin')
            const BottomNavigationBarItem(
              icon: Icon(Icons.edit_note),
              label: 'Manage Booking',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
