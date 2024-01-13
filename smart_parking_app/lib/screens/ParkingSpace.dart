import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/ParkingDetails.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/themes/ColourThemes.dart';
import 'package:smart_parking/screens/NearbyParking.dart';

import 'ManageBooking.dart';
import 'ParkingStatus.dart';

class ParkingSpacePage extends StatefulWidget {
  final User user;

  ParkingSpacePage({required this.user});

  @override
  _ParkingSpacePageState createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
  List<ParkingDetails> _bookings = [];
  bool _isFlipped = false;

  void _toggleCardFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'book-parking.json');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);

      final List<ParkingDetails> loadedBookings = [];

      setState(() {
        _bookings.clear();
        _bookings.addAll(loadedBookings);

        data.forEach((bookingId, bookingData) {
          loadedBookings.add(ParkingDetails(
            id: bookingId,
            vehicleType: bookingData['vehicle-type'],
            plateNumber: bookingData['plate-number'],
            startTime: TimeOfDay(
              hour: int.parse(
                  bookingData['start-time'].toString().split("*").first),
              minute: int.parse(
                  bookingData['start-time'].toString().split("*").last),
            ),
            endTime: TimeOfDay(
              hour: int.parse(
                  bookingData['end-time'].toString().split("*").first),
              minute:
                  int.parse(bookingData['end-time'].toString().split("*").last),
            ),
            address: bookingData['address'],
            slot: bookingData['slot'].toString(),
            userId: bookingData['userId'],
          ));
          print("data = ${bookingData['userId']}");
        });
        _bookings = loadedBookings;
      });
    } catch (error) {
      print('Error fetching bookings: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
        backgroundColor: c3,
        elevation: 0,
        title: Text('Parking Space', style: TextStyle(color: c1)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _fetchBookings();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Text("Click on the card to view other options.",
                    style: TextStyle(color: c1))),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: _toggleCardFlip,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: _isFlipped ? 150.0 : 140.0,
                height: _isFlipped ? 140.0 : 150.0,
                decoration: BoxDecoration(
                  color: c2,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: _isFlipped
                    ? Center(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NearbyParking(user: widget.user)));
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: c3, shape: StadiumBorder()),
                          child: Text(
                            'Look for a parking',
                            style: TextStyle(color: c1, fontSize: 25),
                          ),
                        ),
                      )
                    : Center(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ParkingStatusPage(
                                          //user: widget.user,
                                          // parkingSpot: [],
                                          // parkingDetails: [],
                                        )));
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: c3, shape: StadiumBorder()),
                          child: Text(
                            'Parking Status',
                            style: TextStyle(color: c1, fontSize: 25),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Booking Details',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: c1),
              ),
            ),
            Expanded(
              child: _bookings.isEmpty
                  ? const Center(
                      child: Text('No bookings available'),
                    )
                  : ListView.builder(
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        if (_bookings[index].userId == widget.user.userId) {
                          return Card(
                            shadowColor: c1,
                            color: c2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                'Vehicle Type: ${_bookings[index].plateNumber}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plate Number: ${_bookings[index].vehicleType}',
                                  ),
                                  Text(
                                    'Start Time: ${_bookings[index].startTime.format(context)}',
                                  ),
                                  Text(
                                    'End Time: ${_bookings[index].endTime.format(context)}',
                                  ),
                                  Text('Place: ${_bookings[index].address}'),
                                  Text('Slot: ${_bookings[index].slot}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageBooking(
                                      user: widget.user,
                                      //parkingDetails: _bookings[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        // Returning an empty container for non-matching users
                        return Container();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
