import 'package:binpack_residents/services/logger_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/waste_request.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves a waste collection request to the Firestore database.
  ///
  /// Logs success or failure. If it fails, the error is rethrown for the caller to handle.
  Future<void> saveWasteCollectionRequest(
      WasteCollectionRequest request) async {
    try {
      await _firestore
          .collection('wasteCollectionRequests')
          .doc(request.wasteRequestID)
          .set(request.toJson());
      AppLogger.logInfo(
          'Waste collection request with ID: ${request.wasteRequestID} saved successfully.');
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Failed to save waste collection request with ID: ${request.wasteRequestID}.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generates a new unique waste request ID.
  String generateNewWasteRequestID() {
    final String requestId =
        _firestore.collection('wasteCollectionRequests').doc().id;
    AppLogger.logInfo('Generated new waste request ID: $requestId.');
    return requestId;
  }

  /// Updates an existing waste collection request in the Firestore database.
  ///
  /// Logs success or failure.
  Future<void> updateWasteCollectionRequest(
      String requestId, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore
          .collection('wasteCollectionRequests')
          .doc(requestId)
          .update(updatedFields);
      AppLogger.logInfo(
          'Waste collection request with ID: $requestId updated successfully.');
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Failed to update waste collection request with ID: $requestId.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetches a waste collection request by its ID.
  ///
  /// Returns `null` if the document does not exist.
  Future<WasteCollectionRequest?> fetchWasteCollectionRequestById(
      String requestId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore
              .collection('wasteCollectionRequests')
              .doc(requestId)
              .get();

      if (documentSnapshot.exists) {
        AppLogger.logInfo(
            'Waste collection request with ID: $requestId fetched successfully.');
        return WasteCollectionRequest.fromJson(documentSnapshot.data()!);
      } else {
        AppLogger.logInfo(
            'No waste collection request found with ID: $requestId.');
        return null;
      }
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Failed to fetch waste collection request with ID: $requestId.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
