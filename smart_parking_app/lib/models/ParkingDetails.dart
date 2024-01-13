import 'package:flutter/material.dart';

class ParkingDetails {
  final String id;
  final String address;
  final String slot;
  final String vehicleType;
   String plateNumber;
   TimeOfDay startTime;
   TimeOfDay endTime;
  final String userId;

  ParkingDetails({
    required this.address,
    required this.slot,
    required this.id,
    required this.vehicleType,
    required this.plateNumber,
    required this.startTime,
    required this.endTime,
    required this.userId,
  });

  get numberOfParkingLots => numberOfParkingLots;
}