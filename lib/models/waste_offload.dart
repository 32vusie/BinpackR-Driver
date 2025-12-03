// lib/models/waste_offload.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class WasteOffload {
  final String id;
  final String driverID;
  final List<String> wasteTypes;
  final double totalWeight;
  final String centerName;
  final GeoPoint location;
  final DateTime dateOffloaded;

  WasteOffload({
    required this.id,
    required this.driverID,
    required this.wasteTypes,
    required this.totalWeight,
    required this.centerName,
    required this.location,
    required this.dateOffloaded,
  });

  factory WasteOffload.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteOffload(
      id: doc.id,
      driverID: data['driverID'] ?? '',
      wasteTypes: List<String>.from(data['wasteTypes'] ?? []),
      totalWeight: (data['totalWeight'] ?? 0).toDouble(),
      centerName: data['centerName'] ?? 'Unknown',
      location: data['location'] ?? const GeoPoint(0, 0),
      dateOffloaded: (data['dateOffloaded'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverID': driverID,
      'wasteTypes': wasteTypes,
      'totalWeight': totalWeight,
      'centerName': centerName,
      'location': location,
      'dateOffloaded': dateOffloaded,
    };
  }
}
