import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/users.dart';
import 'Dashboard.dart';
import 'package:smart_parking/models/ParkingStatus.dart';

class StatusChecker extends StatefulWidget {
  final User user;
  final int selectedSlot;

  const StatusChecker({Key? key, required this.user, required this.selectedSlot}) : super(key: key);

  @override
  _StatusCheckerState createState() => _StatusCheckerState();
}

class _StatusCheckerState extends State<StatusChecker> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _isBooking = false;

  Future<void> _performBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isBooking = true;
      });

      final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'start-time': _startTime.toString(),
            'end-time': _endTime.toString(),
            'parking-slot': widget.selectedSlot.toString(), // Include selected slot in the request
          },
        ),
      );

      print(response.body);
      print(response.statusCode);
      _formKey.currentState!.reset();

      // Navigate to the history screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            user: widget.user,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Parking Status'),
        backgroundColor: Colors.black,
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
                    'Selected Parking Slot: ${widget.selectedSlot}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                      onPressed: _isBooking ? null : () => _formKey.currentState!.reset(),
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _isBooking ? null : _checkStatus,
                      child: _isBooking
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                          : const Text('Check Status'),
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

  // Function to check the status for the selected slot and time period
  void _checkStatus() async {
    setState(() {
      _isBooking = true;
    });

    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app', // Replace with your backend URL
      'book-parking.json',
      {
        'slot': widget.selectedSlot.toString(),
        'start-time': _startTime.toString(),
        'end-time': _endTime.toString(),
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final statusData = json.decode(response.body);

        // Assuming your status endpoint returns a JSON with 'isAvailable' and 'message' fields
        final parkingStatus = ParkingStatus(
          isAvailable: statusData['isAvailable'],
          message: statusData['message'],
        );

        _showStatusDialog(parkingStatus);
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        _showStatusDialog(ParkingStatus(isAvailable: false, message: 'Error checking status'));
      }
    } catch (error) {
      // Handle network error
      print('Error: $error');
      _showStatusDialog(ParkingStatus(isAvailable: false, message: 'Error checking status'));
    } finally {
      setState(() {
        _isBooking = false;
      });
    }
  }

  void _showStatusDialog(ParkingStatus parkingStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Status Check'),
          content: Text('The parking status is: ${parkingStatus.isAvailable ? 'Available' : 'Not Available'}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
