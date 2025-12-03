import 'package:cloud_firestore/cloud_firestore.dart';

class Depot {
  final String depotID;
  final String name;
  final String address;
  final GeoPoint location;
  final String imageUrl;

  Depot({
    required this.depotID,
    required this.name,
    required this.address,
    required this.location,
    required this.imageUrl,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      depotID: json['depotID'],
      name: json['name'],
      address: json['address'],
      location: json['location'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'depotID': depotID,
        'name': name,
        'address': address,
        'location': location,
        'imageUrl': imageUrl,
      };
}
