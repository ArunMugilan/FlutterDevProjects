import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/ParkingDetails.dart';
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class ManageBooking extends StatefulWidget {
  final User user;

  // final ParkingDetails parkingDetails;

  const ManageBooking({Key? key, required this.user}) : super(key: key);

  @override
  _ManageBookingState createState() => _ManageBookingState();
}

class _ManageBookingState extends State<ManageBooking> {
  List<ParkingDetails> bookings = [];
  List<ParkingSpot> ps = [];

  // List<String> addresses = [];
  // List<int> numberOfSpots = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
    getAddressesAndSlots();
    // fetchAddressAndSpotsData();
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
            minute:
                int.parse(bookingData['start-time'].toString().split('*')[1]));
        TimeOfDay endTime = TimeOfDay(
            hour: int.parse(bookingData['end-time'].toString().split('*')[0]),
            minute:
                int.parse(bookingData['end-time'].toString().split('*')[1]));

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
        bookings = loadedBookings;
      });
    } catch (error) {
      print('Error fetching bookings: $error');
    }
  }

  void getAddressesAndSlots() async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'add-parking.json',
    );
    List<ParkingSpot> tempList = [];
    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200) {
        for (final something in data.entries) {
          tempList.add(ParkingSpot(
            id: something.key,
            address: something.value['address'],
            numberOfParkingLots: something.value['nOfSpots'],
          ));
        }
        ps = tempList;
      } else {
        print("fail");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateBooking(ParkingDetails booking) async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'book-parking/${booking.id}.json',
    );

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'start-time':
                "${booking.startTime.hour}*${booking.startTime.minute}",
            // Convert DateTime to String
            'end-time': "${booking.endTime.hour}*${booking.endTime.minute}",
            // Convert DateTime to String
            'plate-number': booking.plateNumber,
            'vehicle-type': booking.vehicleType,
            'address': booking.address,
            'slot': booking.slot
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Booking updated successfully');
      } else {
        print('Failed to update booking: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating booking: $error');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'book-parking/$bookingId.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Booking deleted successfully');
      } else {
        print('Failed to delete booking: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting booking: $error');
    }
    fetchBookings();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
        backgroundColor: c3,
        elevation: 0,
        centerTitle: true,
        title: Text('Manage Booking', style: TextStyle(color: c1)),
        actions: [
          IconButton(
              onPressed: () {
                fetchBookings();
              },
              icon: Icon(
                Icons.refresh,
                color: c1,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          // Check if the booking belongs to the current user
          if (booking.userId == widget.user.userId) {
            return Card(
              margin: const EdgeInsets.all(10),
              color: c2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.local_parking_rounded),
                title: Text('Address: ${booking.address}'),
                subtitle: Text(
                  'Plate Number: ${booking.plateNumber}\n'
                  'Start Time: ${booking.startTime.format(context)}\n'
                  'End Time: ${booking.endTime.format(context)}\n'
                  'Vehicle: ${booking.vehicleType}\n'
                  'Spot Number: ${booking.slot}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String editedPlateNumber = booking.plateNumber;
                            TimeOfDay editedStartTime = booking.startTime;
                            TimeOfDay editedEndTime = booking.endTime;
                            String editedAddress = booking.address;
                            int editedSlot = int.parse(booking.slot);
                            ParkingSpot address = ps.first;
                            List<int> selectedParkingSpot = List.generate(
                                address.numberOfParkingLots,
                                (index) => index++);
                            int slot = selectedParkingSpot.first;
                            return AlertDialog(
                              content: Column(
                                children: [
                                  TextFormField(
                                    initialValue: booking.plateNumber,
                                    onChanged: (value) {
                                      editedPlateNumber = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Plate Number',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        booking.startTime.format(context),
                                    onTap: () async {
                                      // Show time picker and update editedStartTime
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: booking.startTime,
                                      );

                                      if (pickedTime != null &&
                                          pickedTime != booking.startTime) {
                                        setState(() {
                                          booking.startTime = pickedTime;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Start Time',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        booking.endTime.format(context),
                                    onTap: () async {
                                      // Show time picker and update editedEndTime
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: booking.endTime,
                                      );

                                      if (pickedTime != null &&
                                          pickedTime != booking.endTime) {
                                        setState(() {
                                          booking.endTime = pickedTime;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'End Time',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DropdownMenu<ParkingSpot>(
                                    enableSearch: true,
                                    // width: MediaQuery.of(context).size.width * 0.5,
                                    initialSelection:
                                        ps.isNotEmpty ? ps.first : null,
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
                                        ps.map<DropdownMenuEntry<ParkingSpot>>(
                                      (ParkingSpot value) {
                                        return DropdownMenuEntry<ParkingSpot>(
                                          value: value,
                                          label: value.address.toUpperCase(),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                  )
                                ],
                              ),
                              title: const Text('Edit Booking'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Call the updateBooking method with edited values
                                    updateBooking(ParkingDetails(
                                      id: booking.id,
                                      plateNumber: editedPlateNumber,
                                      startTime: editedStartTime,
                                      endTime: editedEndTime,
                                      vehicleType: booking.vehicleType,
                                      address: editedAddress,
                                      slot: editedSlot.toString(),
                                      userId: widget.user.userId,
                                    ));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Booking'),
                            content: const Text(
                                'Are you sure you want to delete this booking?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Call the deleteBooking method
                                  deleteBooking(booking.id);
                                  Navigator.pop(context); // Close the dialog
                                  // You might want to refresh the UI after deletion
                                  fetchBookings();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            // For bookings that don't belong to the current user, return an empty container
            return Container();
          }
        },
      ),
    );
  }
}
