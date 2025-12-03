import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GoogleMapsService {
  // Get the current location
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } on Exception catch (e) {
      print(e);
      return Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,  // Add this line
        heading: 0,
        headingAccuracy: 0,  // Add this line
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  // Get the address from a location
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return '${place.street}, ${place.locality}, ${place.country}';
    } on Exception catch (e) {
      print(e);
      return 'Unknown';
    }
  }

  // Calculate the distance between two locations in meters
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const Distance distance = Distance();
    return distance(
      LatLng(lat1, lng1),
      LatLng(lat2, lng2),
    );
  }
}
