class ParkingRequest {
  final String id;
  final String address;
  final int selectedSlot;
  final String vehicleType;
  final String plateNumber;
  final DateTime startTime;
  final DateTime endTime;

  ParkingRequest({
    required this.id,
    required this.address,
    required this.selectedSlot,
    required this.vehicleType,
    required this.plateNumber,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slot-number': selectedSlot,
      'vehicle-type': vehicleType,
      'plate-number': plateNumber,
      'start-time': startTime.toIso8601String(),
      'end-time': endTime.toIso8601String()
    };
  }
}
