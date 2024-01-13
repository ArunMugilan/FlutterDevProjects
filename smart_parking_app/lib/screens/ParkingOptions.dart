import 'package:flutter/material.dart';
import 'package:smart_parking/models/ParkingSpot.dart';
import 'package:smart_parking/models/users.dart';
import 'package:smart_parking/screens/StatusChecker.dart';
import 'package:smart_parking/models/ParkingDetails.dart';

class ParkingOptions extends StatelessWidget {
  final User user;
  final ParkingSpot parkingSpot;

  const ParkingOptions({Key? key, required this.parkingSpot, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> availableSlots =
    List.generate(parkingSpot.numberOfParkingLots, (index) => index + 1);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a slot'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Hero(
          //   tag: 'parkingSpotImage${parkingSpot.id}',
          //   child: Image.asset(
          //     parkingSpot.imageUrl,
          //     width: 200,
          //     height: 200,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          const SizedBox(height: 16),
          Text('Address: ${parkingSpot.address}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontStyle: FontStyle.italic),),
          Text('Available lots: ${parkingSpot.numberOfParkingLots}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontStyle: FontStyle.italic),),
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
                return ListTile(
                  title: Text('Slot $slotNumber'),
                  onTap: () {
                    // Navigate to BookParking screen when a slot is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatusChecker(
                            selectedSlot: slotNumber, user: user
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
