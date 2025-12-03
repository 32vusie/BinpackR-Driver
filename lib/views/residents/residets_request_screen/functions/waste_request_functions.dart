import 'package:binpack_residents/services/logger_service.dart';
import 'package:binpack_residents/services/waste_request/geocoding_service.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/functions/loadingbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../models/incentives.dart';
import 'package:lottie/lottie.dart';

class WasteTypeDropdownMap {
  Future<List<DropdownMenuItem<WasteType>>>
      buildWasteTypeDropdownItems() async {
    return WasteType.values
        .map((type) => DropdownMenuItem<WasteType>(
              value: type,
              child: Text(getWasteTypeId(type)),
            ))
        .toList();
  }
}

Future<void> submitNormalRequest({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required List<WasteType> wasteTypes,
  required double wasteWeight,
  required String qrInfo,
  required String location,
  required List<Incentive> incentives,
  DateTime? scheduledDateTime,
  bool? isEventCollection,
}) async {
  if (!_validateForm(formKey)) return;

  final geocodingService = GeocodingService();

  showLoadingOverlay(context);
  try {
    final wasteRequestID = generateWasteRequestID();
    final userID = _getCurrentUserId();
    final wasteTypeID = wasteTypes.map(getWasteTypeId).toList();
    final date = scheduledDateTime ?? DateTime.now();
    final updatedDateTime = DateTime.now();
    final geoLocation =
        await geocodingService.fetchGeoPointFromAddress(location);

    final wasteRequest = WasteCollectionRequest(
      wasteRequestID: wasteRequestID,
      userID: userID,
      wasteTypeID: wasteTypeID,
      date: date,
      location: geoLocation,
      imageUrl: 'noqrcode',
      driverID: '',
      status: scheduledDateTime == null ? 'pending' : 'scheduled',
      weight: wasteWeight,
      qrInfo: qrInfo,
      notificationSent: false,
      incentive: 0.00,
      rating: 0.0,
      isEventCollection: isEventCollection,
      updatedDateTime: updatedDateTime,
    );

    await _saveWasteRequest(wasteRequest);
    hideLoadingOverlay();
    _showSuccessDialog(context, wasteRequestID);
  } catch (error, stackTrace) {
    AppLogger.logError(
      'Error in submitNormalRequest',
      error: error,
      stackTrace: stackTrace,
    );
    hideLoadingOverlay();
    _showErrorDialog(context, 'Error submitting request. Please try again.');
  }
}

Future<void> submitPaidRequest({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required List<WasteType> wasteTypes,
  required double wasteWeight,
  required String qrInfo,
  required String location,
  required List<Incentive> incentives,
  required double paymentAmount,
  DateTime? scheduledDateTime,
  String? paymentMethodId,
  bool? isEventCollection,
}) async {
  if (!_validateForm(formKey)) return;

  final geocodingService = GeocodingService();

  showLoadingOverlay(context);
  try {
    final wasteRequestID = generateWasteRequestID();
    final userID = _getCurrentUserId();
    final wasteTypeID = wasteTypes.map(getWasteTypeId).toList();
    final date = scheduledDateTime ?? DateTime.now();
    final updatedDateTime = DateTime.now();
    final geoLocation =
        await geocodingService.fetchGeoPointFromAddress(location);

    final wasteRequest = WasteCollectionRequest(
      wasteRequestID: wasteRequestID,
      userID: userID,
      wasteTypeID: wasteTypeID,
      date: date,
      location: geoLocation,
      imageUrl: 'noqrcode',
      driverID: '',
      status: scheduledDateTime == null ? 'paid' : 'scheduled-paid',
      weight: wasteWeight,
      qrInfo: qrInfo,
      notificationSent: false,
      incentive: paymentAmount,
      rating: 0.0,
      paymentMethodId: paymentMethodId,
      isEventCollection: isEventCollection,
      updatedDateTime: updatedDateTime,
    );

    await _saveWasteRequest(wasteRequest);
    hideLoadingOverlay();
    _showSuccessDialog(context, wasteRequestID);
  } catch (error, stackTrace) {
    AppLogger.logError(
      'Error in submitPaidRequest',
      error: error,
      stackTrace: stackTrace,
    );
    hideLoadingOverlay();
    _showErrorDialog(
        context, 'Error submitting paid request. Please try again.');
  }
}

bool _validateForm(GlobalKey<FormState> formKey) {
  final form = formKey.currentState;
  if (form == null || !form.validate()) {
    print('Form validation failed.');
    return false;
  }
  form.save();
  return true;
}

String _getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('No authenticated user found.');
  return user.uid;
}

Future<void> _saveWasteRequest(WasteCollectionRequest wasteRequest) async {
  await FirebaseFirestore.instance
      .collection('wasteCollectionRequests')
      .doc(wasteRequest.wasteRequestID)
      .set(wasteRequest.toJson());
}

void _showSuccessDialog(BuildContext context, String userID) {
  showDialog(
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async => false, // Prevent closing by tapping outside
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: primaryColor, size: 30),
            SizedBox(width: 8),
            Text(
              'Request Submitted!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie animation for success
            Lottie.asset(
              'assets/Animation-1732197200954.json', // Add your Lottie animation file to assets
              width: 150,
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your waste collection request has been submitted successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Request ID: $userID',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for keeping the environment clean!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Back to Requests'),
          ),
        ],
      ),
    ),
  );
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

String generateWasteRequestID() {
  return FirebaseFirestore.instance
      .collection('wasteCollectionRequests')
      .doc()
      .id;
}
