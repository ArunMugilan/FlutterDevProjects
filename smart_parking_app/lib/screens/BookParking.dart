import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/models/users.dart';
import 'Dashboard.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class BookParking extends StatefulWidget {
  final User user;
  final int selectedSlot;
  final ParkingSpot ps;

  const BookParking(
      {Key? key,
      required this.user,
      required this.selectedSlot, required this.ps})
      : super(key: key);

  @override
  _BookParkingState createState() => _BookParkingState();
}

class _BookParkingState extends State<BookParking> {
  final _formKey = GlobalKey<FormState>();
  String _selectedVehicleType = 'Car';
  String _vehiclePlateNumber = '';

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _isBooking = false;

  // Define parking charges based on vehicle type
  final Set<String> _vehicleTypes = {
    'Motorcycle',
    'Car',
    'Lorry',
    'Van',
  };

  Future<void> _performBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isBooking = true;
      });

      final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'book-parking.json',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'address': widget.ps.address,
            'slot': widget.selectedSlot,
            'vehicle-type': _selectedVehicleType,
            'plate-number': _vehiclePlateNumber,
            'start-time': "${_startTime.hour.toString()}*${_startTime.minute.toString()}",
            'end-time': "${_endTime.hour.toString()}*${_endTime.minute.toString()}",
            'userId': widget.user.userId,
          },
        ),
      );

      print(response.body);
      print(response.statusCode);
      _formKey.currentState!.reset();

      // Navigate to the history screen
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx) {
            return Dashboard(user: widget.user);
          }), (route)=>false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Book Parking'),
        backgroundColor: c1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Selected Parking Spot: ${widget.selectedSlot}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField(
                      value: _selectedVehicleType,
                      items: _vehicleTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedVehicleType = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelStyle: TextStyle(color: c1),
                        labelText: 'Vehicle Type',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _vehiclePlateNumber = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Plate Number',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the vehicle plate number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'Start Time: $_startTime',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _startTime,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'End Time: $_endTime',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _endTime,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _endTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isBooking
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: Text('Reset', style: TextStyle(color: c1)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: c2),
                      onPressed: _isBooking ? null : _performBooking,
                      child: _isBooking
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text('Book',style: TextStyle(color: c1)),
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
