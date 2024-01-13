import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class ManageParking extends StatefulWidget {
  @override
  _ManageParkingState createState() => _ManageParkingState();
}

class _ManageParkingState extends State<ManageParking> {
  List<ParkingSpot> parkingSpot = [];

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
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
        parkingSpot = loadedParkingSpots;
      });
    } catch (error) {
      print('Error fetching parking spots: $error');
    }
  }

  Future<void> updateParkingSpot(ParkingSpot parkingSpot) async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'add-parking/${parkingSpot.id}.json',
    );

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'address': parkingSpot.address,
            'nOfSpots': parkingSpot.numberOfParkingLots,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Parking spot updated successfully');
      } else {
        print('Failed to update parking spot: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating parking spot: $error');
    }
  }

  Future<void> deleteParkingSpot(String parkingSpotId) async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'add-parking/$parkingSpotId.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Parking spot deleted successfully');
      } else {
        print('Failed to delete parking spot: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting parking spot: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      body: FutureBuilder(
          future: _fetchParkingSpots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: parkingSpot.length,
              itemBuilder: (context, index) {
                final pd = parkingSpot[index];
                return Card(
                  margin: const EdgeInsets.all(15),
                  color: c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.local_parking),
                    title: Text(pd.address),
                    subtitle: Text('Available lots: ${pd.numberOfParkingLots}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // Variables to store edited values
                                String editedAddress = pd.address;
                                int editedNumberOfSpots =
                                    pd.numberOfParkingLots;
                                return AlertDialog(
                                  title: const Text('Edit Parking Spot'),
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        initialValue: pd.address,
                                        onChanged: (value) {
                                          editedAddress = value;
                                        },
                                        decoration: const InputDecoration(
                                            labelText: 'Address'),
                                      ),
                                      TextFormField(
                                        initialValue:
                                            pd.numberOfParkingLots.toString(),
                                        onChanged: (value) {
                                          editedNumberOfSpots =
                                              int.tryParse(value) ?? 0;
                                        },
                                        decoration: const InputDecoration(
                                            labelText: 'Number of Spots'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Call the updateParkingSpot method with edited values
                                        updateParkingSpot(ParkingSpot(
                                          id: pd.id,
                                          address: editedAddress,
                                          numberOfParkingLots:
                                              editedNumberOfSpots,
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
                                title: const Text('Delete Parking Spot'),
                                content: const Text(
                                    'Are you sure you want to delete this parking spot?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteParkingSpot(pd.id);
                                      Navigator.pop(
                                          context); // Close the dialog
                                      // You might want to refresh the UI after deletion
                                      _fetchParkingSpots();
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
              },
            );
          }),
    );
  }
}
