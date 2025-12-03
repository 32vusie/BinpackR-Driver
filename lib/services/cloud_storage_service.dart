// cloud_storage_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final FirebaseStorage _firebaseStorage;

  CloudStorageService(this._firebaseStorage);

  // Upload a file
  Future<String> uploadFile(String filePath, String storagePath) async {
    File file = File(filePath);
    try {
      await _firebaseStorage.ref(storagePath).putFile(file);
      return await getDownloadUrl(storagePath);
    } on FirebaseException catch (e) {
      print(e.message);
      return '';
    }
  }

  // Get the download URL of a file
  Future<String> getDownloadUrl(String path) async {
    try {
      return await _firebaseStorage.ref(path).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.message);
      return '';
    }
  }

  // Delete a file
  Future<void> deleteFile(String path) async {
    try {
      await _firebaseStorage.ref(path).delete();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
