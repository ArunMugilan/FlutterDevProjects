import 'dart:convert';

import 'package:smart_parking/models/ParkingDetails.dart';
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:http/http.dart' as http;

Future<List<ParkingSpot>> fetchParkingSpots() async {
  final url = Uri.https(
    'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
    'add-parking.json',
  );

  try {
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);

    final List<ParkingSpot> loadedParkingSpots = [];

    data.forEach((parkingId, parkingData) {
      DateTime startTime = DateTime.parse(parkingData['start-time']);
      DateTime endTime = DateTime.parse(parkingData['end-time']);
      loadedParkingSpots.add(ParkingSpot(
        id: parkingId,
        address: parkingData['address'],
        numberOfParkingLots: parkingData['nOfParking'],
      ));
    });

    return loadedParkingSpots;
  } catch (error) {
    print('Error fetching parking spots: $error');
    return [];
  }
}
