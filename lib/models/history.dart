import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String historyID;
  final String type; // pickup or drop-off
  final String wasteTypeID;
  final DateTime date;
  final GeoPoint location;
  final String driverID;
  final String status;

  History({
    required this.historyID,
    required this.type,
    required this.wasteTypeID,
    required this.date,
    required this.location,
    required this.driverID,
    required this.status,
  });

 factory History.fromJson(Map<String, dynamic> json) {
  return History(
    historyID: json['historyID'] ?? '',
    type: json['type'] ?? '',
    wasteTypeID: json['wasteTypeID'] ?? '',
    date: json['date'] != null ? (json['date'] as Timestamp).toDate() : DateTime.now(),
    location: json['location'] != null ? GeoPoint(
      (json['location']['latitude'] as num).toDouble(),
      (json['location']['longitude'] as num).toDouble(),
    ) : const GeoPoint(0, 0),
    driverID: json['driverID'] ?? '',
    status: json['status'] ?? '',
  );
}




  Map<String, dynamic> toJson() => {
        'historyID': historyID,
        'type': type,
        'wasteTypeID': wasteTypeID,
        'date': date,
        'location': location,
        'driverID': driverID,
        'status': status,
      };
}
