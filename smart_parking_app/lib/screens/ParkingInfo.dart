import 'package:flutter/material.dart';
import 'package:smart_parking/models/ParkingSpot.dart';
import 'BookParking.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class ParkingInfo extends StatelessWidget {
  final User user;
  final ParkingSpot parkingSpot;

  const ParkingInfo({Key? key, required this.parkingSpot, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> availableSlots =
        List.generate(parkingSpot.numberOfParkingLots, (index) => index + 1);

    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text('Parking Information'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Address: ${parkingSpot.address}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
          Text(
            'Available lots: ${parkingSpot.numberOfParkingLots}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select a Parking Slot:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final int slotNumber = availableSlots[index];
                return Card(

                  color: c1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    title: Text('Slot $slotNumber', style: TextStyle(color: c5)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookParking(
                            selectedSlot: slotNumber,
                            user: user,
                            ps: parkingSpot,
                          ),
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
