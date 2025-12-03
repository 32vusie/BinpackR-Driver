import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getAddress(GeoPoint location) async {
  final placemarks = await placemarkFromCoordinates(
    location.latitude,
    location.longitude,
  );

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    return '${place.street}, ${place.locality}, ${place.country}';
  }

  return 'Address not available';
}