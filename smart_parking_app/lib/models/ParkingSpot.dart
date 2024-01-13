class ParkingSpot {
  final String id;
  final String address;
  final int numberOfParkingLots;

  ParkingSpot({
    required this.id,
    required this.address,
    required this.numberOfParkingLots,
  });

  get bookedSlots => bookedSlots;
}