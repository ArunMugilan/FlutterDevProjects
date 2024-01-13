import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'BookParking.dart';
import 'package:smart_parking/models/users.dart';
import 'ParkingInfo.dart';
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/themes/ColourThemes.dart';


class NearbyParking extends StatefulWidget {
  final User user;

  const NearbyParking({super.key, required this.user});
  @override
  _NearbyParkingState createState() => _NearbyParkingState();
}

class _NearbyParkingState extends State<NearbyParking> {
  List<ParkingSpot> ps = [];

  List<ParkingSpot> filteredParkingSpots = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchParkingSpots();
    filteredParkingSpots = ps;
  }

  void searchParking(String query) {
    setState(() {
      filteredParkingSpots = ps
          .where((spot) => spot.address.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> fetchParkingSpots() async {
    final url = Uri.https(
      'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
      'add-parking.json',
    );

    try {
      final response = await http.get(url);
      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        print("Data = ${response.body}");
        final List<ParkingSpot> loadedParkingSpots = [];

        data.forEach((bookingId, bookingData) {

          loadedParkingSpots.add(ParkingSpot(
            id: bookingId,
            address: bookingData['address'],
            numberOfParkingLots: bookingData['nOfSpots'],
          ));
        });


        setState(() {
          ps = loadedParkingSpots;
        });
      }else{
        print("Nearby parking class => response = ${response.statusCode}");
      }
    } catch (error) {
      print('Error fetching parking spots: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c1,
        centerTitle: true,
        title: const Text('Nearby Parking'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: searchParking,
              decoration: InputDecoration(
                labelText: "Search Parking",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredParkingSpots.length,
              itemBuilder: (context, index) {
                return Card(
                  color: c1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    title: Text(filteredParkingSpots[index].address, style: TextStyle(color: c5),),
                    subtitle: Text(
                        'Available lots: ${filteredParkingSpots[index].numberOfParkingLots}',style: TextStyle(color: c5)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParkingInfo(
                              parkingSpot: filteredParkingSpots[index], user: widget.user,),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
