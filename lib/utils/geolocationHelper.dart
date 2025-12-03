// lib/utils/geolocation_helper.dart
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeolocationHelper {
  static Future<GeoPoint> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        return GeoPoint(position.latitude, position.longitude);
      } else {
        throw Exception("Location permission denied.");
      }
    } catch (e) {
      print("Error getting location: $e");
      return const GeoPoint(0, 0); // Default to a null location
    }
  }
}
