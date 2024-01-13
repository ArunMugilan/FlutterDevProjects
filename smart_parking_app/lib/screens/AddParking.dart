import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Dashboard.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/methods/FetchParking.dart';
import 'package:smart_parking/themes/ColourThemes.dart';


class AddParkingPage extends StatefulWidget {
  final User user;

  const AddParkingPage({Key? key, required this.user}) : super(key: key);

  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberOfParkingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAddingSpot = false;

  Future<void> _addParking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isAddingSpot = true;
      });

      try {
        final url = Uri.https(
          'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
          'add-parking.json',
        );

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'address': _addressController.text,
              'nOfSpots': int.parse(_numberOfParkingController.text),
            },
          ),
        );

        print(response.body);
        print(response.statusCode);

        // Handle response as needed

        // Reset the form
        _formKey.currentState!.reset();

        // Navigate to the dashboard screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              user: widget.user,
            ),
          ),
        );
        final updatedParkingSpots = await fetchParkingSpots();

      } catch (e) {
        print('Error adding parking spot: $e');
      } finally {
        setState(() {
          _isAddingSpot = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: c2,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberOfParkingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Parking Lots',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: c2,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of parking lots';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isAddingSpot
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: Text('Reset', style: TextStyle(color: c1)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: c5),
                    onPressed: _isAddingSpot ? null : _addParking,
                    child: _isAddingSpot
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Add',style: TextStyle(color: c1)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
