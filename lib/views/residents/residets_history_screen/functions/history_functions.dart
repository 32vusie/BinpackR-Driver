import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/users/driver.dart';
import 'package:logger/logger.dart';

class DriverService {
  static final Logger _logger = Logger();

  /// Fetches a [Driver] object from Firestore based on the provided [driverID].
  ///
  /// Returns the [Driver] object if found, or `null` if no data exists for the given ID.
  /// Uses structured logging for better monitoring and debugging.
  static Future<Driver?> fetchDriver(String driverID) async {
    if (driverID.trim().isEmpty) {
      _logger.w('DriverService: Provided driverID is empty or invalid.');
      return null;
    }

    try {
      // Fetch the driver document from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverID)
          .get();

      if (!doc.exists) {
        _logger.i('DriverService: No driver found with ID: $driverID');
        return null;
      }

      // Convert Firestore data into a Driver object
      final driverData = doc.data();
      if (driverData != null) {
        _logger.d(
            'DriverService: Successfully fetched driver data for ID: $driverID');
        return Driver.fromJson(driverData);
      } else {
        _logger.w('DriverService: Driver data is null for ID: $driverID');
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e(
        'DriverService: Error fetching driver with ID: $driverID',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
