import 'dart:typed_data';
import 'package:binpack_residents/services/logger_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QRCodeService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// Uploads the QR code image to Firebase Storage and returns its download URL.
  ///
  /// If the upload fails, an empty string is returned.
  Future<String> uploadQRCodeToStorage({
    required List<int> qrCodeData,
    required String requestId,
  }) async {
    try {
      final storageReference = _firebaseStorage.ref();
      final qrCodeRef = storageReference.child('qr_codes/$requestId.png');

      await qrCodeRef.putData(Uint8List.fromList(qrCodeData));
      AppLogger.logInfo(
          'QR code uploaded successfully for request ID: $requestId.');
      return await qrCodeRef.getDownloadURL();
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Failed to upload QR code for request ID: $requestId.',
        error: error,
        stackTrace: stackTrace,
      );
      return '';
    }
  }

  /// Generates a placeholder QR code URL for the given information.
  ///
  /// Replace the placeholder logic with actual QR code generation logic.
  Future<String> generateQRCode({required String qrInfo}) async {
    try {
      // Add actual QR code generation logic here.
      final placeholderUrl = 'https://placeholder.qr.code/$qrInfo';
      AppLogger.logInfo('QR code generated successfully for info: $qrInfo.');
      return placeholderUrl;
    } catch (error, stackTrace) {
      AppLogger.logError(
        'Failed to generate QR code for info: $qrInfo.',
        error: error,
        stackTrace: stackTrace,
      );
      return '';
    }
  }
}
