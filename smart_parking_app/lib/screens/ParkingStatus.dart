import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/models/ParkingDetails.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class ParkingStatusPage extends StatefulWidget {
  @override
  _ParkingStatusPageState createState() => _ParkingStatusPageState();
}

class _ParkingStatusPageState extends State<ParkingStatusPage> {
  late String selectedAddress;
  late String selectedSlot;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  List<ParkingSpot> parkingSpots = [];
  List<ParkingDetails> bookedSlots = [];

  @override
  void initState() {
    super.initState();
    selectedAddress = '';
    selectedSlot = '';
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
    // Fetch parking spots from the database
    fetchParkingSpots();
  }

  Future<void> fetchBookings() async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'book-parking.json',
    );

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);

      final List<ParkingDetails> loadedBookings = [];

      data.forEach((bookingId, bookingData) {
        // Convert the start-time and end-time strings to DateTime
        TimeOfDay startTime = TimeOfDay(
          hour: int.parse(bookingData['start-time'].toString().split('*')[0]),
          minute: int.parse(bookingData['start-time'].toString().split('*')[1]),
        );
        TimeOfDay endTime = TimeOfDay(
          hour: int.parse(bookingData['end-time'].toString().split('*')[0]),
          minute: int.parse(bookingData['end-time'].toString().split('*')[1]),
        );

        loadedBookings.add(ParkingDetails(
          id: bookingId,
          startTime: startTime,
          endTime: endTime,
          plateNumber: bookingData['plate-number'],
          vehicleType: bookingData['vehicle-type'],
          address: bookingData['address'],
          slot: bookingData['slot'].toString(),
          userId: bookingData['userId'],
        ));
      });

      setState(() {
        bookedSlots = loadedBookings;
      });
    } catch (error) {
      print('Error fetching bookings: $error');
    }
  }

  Future<void> fetchParkingSpots() async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'add-parking.json',
    );

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);

      final List<ParkingSpot> loadedParkingSpots = [];

      data.forEach((parkingSpotId, parkingSpotData) {
        loadedParkingSpots.add(ParkingSpot(
          id: parkingSpotId,
          address: parkingSpotData['address'],
          numberOfParkingLots: parkingSpotData['nOfSpots'],
        ));
      });

      setState(() {
        parkingSpots = loadedParkingSpots;
      });
    } catch (error) {
      print('Error fetching parking spots: $error');
    }
  }

  List<int> getAvailableSlots() {
    ParkingSpot selectedParkingSpot = parkingSpots.firstWhere(
      (spot) => spot.address == selectedAddress,
      orElse: () => ParkingSpot(id: '', address: '', numberOfParkingLots: 0),
    );

    List<int> allSlots = List.generate(
      selectedParkingSpot.numberOfParkingLots,
      (index) => index + 1,
    );

    List<int> bookedSlotsForSelectedTime(List<ParkingDetails> bookedSlots, String selectedAddress, String selectedSlot, TimeOfDay selectedStartTime, TimeOfDay selectedEndTime) {
      List<int> result = [];

      for (ParkingDetails slot in bookedSlots) {
        if (slot.address == selectedAddress &&
            slot.slot == selectedSlot &&
            (slot.startTime.hour == selectedStartTime.hour && slot.startTime.minute == selectedStartTime.minute) &&
            (slot.endTime.hour == selectedEndTime.hour && slot.endTime.minute == selectedEndTime.minute)) {
          result.add(int.parse(slot.slot));
        }
      }

      return result;
    }

    List<int> availableSlots = allSlots
        .where((slot) => !bookedSlotsForSelectedTime(bookedSlots, selectedAddress, selectedSlot, selectedStartTime, selectedEndTime).contains(slot))
        .toList();

    return availableSlots;
  }

  @override
  Widget build(BuildContext context) {
    ParkingSpot address = parkingSpots.first;
    List<int> selectedParkingSpot = List.generate(
        address.numberOfParkingLots,
            (index) => index++);
    int slot = selectedParkingSpot.first;
    return Scaffold(
      backgroundColor: c2,
      appBar: AppBar(
        backgroundColor: c1,
        centerTitle: true,
        title: Text('Parking Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<ParkingSpot>(
              enableSearch: true,
              // width: MediaQuery.of(context).size.width * 0.5,
              initialSelection:
              parkingSpots.isNotEmpty ? parkingSpots.first : null,
              onSelected: (ParkingSpot? value) {
                // This is called when the user selects an item.
                setState(() {
                  address = value!;
                  selectedParkingSpot = List.generate(
                    address.numberOfParkingLots,
                        (index) => index + 1,
                  );
                });
                print("address is =${address.address}");
              },
              dropdownMenuEntries:
              parkingSpots.map<DropdownMenuEntry<ParkingSpot>>(
                    (ParkingSpot value) {
                  return DropdownMenuEntry<ParkingSpot>(
                    value: value,
                    label: value.address.toUpperCase(),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedParkingSpot.first,
              onChanged: (int? value) {
                setState(() {
                  slot = value!;
                });
                print("slot is =$slot");
              },
              items: selectedParkingSpot.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Spot $value'),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select Spot Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: c1),
              onPressed: () async {
                await _selectTime(context, true);
              },
              child: Text(
                  'Select Start Time: ${selectedStartTime.format(context)}', style: TextStyle(color: c5)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: c1),
              onPressed: () async {
                await _selectTime(context, false);
              },
              child:
                  Text('Select End Time: ${selectedEndTime.format(context)}', style: TextStyle(color: c5)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: c1),
              onPressed: () {
                _checkAvailability();
              },
              child: Text('Check Availability', style: TextStyle(color: c5)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? selectedStartTime : selectedEndTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          selectedStartTime = pickedTime;
        } else {
          selectedEndTime = pickedTime;
        }
      });
    }
  }

  void _checkAvailability() {
    // Check parking availability and show the corresponding alert
    List<int> availableSlots = getAvailableSlots();
    availableSlots.isNotEmpty
        ? _showAlertDialog('Parking Available', Colors.green)
        : _showAlertDialog('Parking Occupied', Colors.red);
  }

  void _showAlertDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          backgroundColor: color,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
