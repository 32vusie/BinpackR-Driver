import 'package:binpack_residents/services/logger_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeocodingService {
  /// Fetches a `GeoPoint` from a given address.
  ///
  /// If the address cannot be resolved, returns a default `GeoPoint(0, 0)`.
  Future<GeoPoint> fetchGeoPointFromAddress(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        AppLogger.logInfo(
            'GeoPoint fetched successfully for address: $address.');
        return GeoPoint(location.latitude, location.longitude);
      } else {
        AppLogger.logInfo('No GeoPoint found for address: $address.');
      }
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Error while fetching GeoPoint for address: $address.',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return const GeoPoint(0, 0);
  }

  /// Fetches latitude and longitude (`LatLng`) from a given address.
  ///
  /// Returns `null` if the address cannot be resolved.
  Future<LatLng?> fetchCoordinatesFromAddress(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        AppLogger.logInfo(
            'Coordinates fetched successfully for address: $address.');
        return LatLng(location.latitude, location.longitude);
      } else {
        AppLogger.logInfo('No coordinates found for address: $address.');
      }
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Error while fetching coordinates for address: $address.',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }
}
