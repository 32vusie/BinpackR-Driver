import 'dart:io';

import 'package:binpack_residents/models/users/resident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthService(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument(
      User user, String name, String role, String cellNumber) async {
    await _firestore.collection('users').doc(user.uid).set({
      'userID': user.uid,
      'name': name,
      'email': user.email,
      'role': role,
      'profilePictureUrl': '',
      'registrationDate': DateTime.now(),
      'lastActive': DateTime.now(),
      'cellNumber': cellNumber,
      'accountInfo': {
        'accountNumber': '',
        'balance': 0.0,
        'cardInfo': {
          'cardNumber': '',
          'cardExpiry': '',
          'cardCSV': 0,
          'pin': ''
        },
      },
      'rewardPoints': 0,
      'wardId': ''
    });
  }

  Future<Residents?> signUp({
    required String username,
    required String email,
    required String cellNumber,
    required String password,
    required String role,
    String? vehicleType,
  }) async {
    try {
      // Get the device ID
      String? deviceId = await getDeviceId();
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Create user document in Firestore
      await createUserDocument(
          userCredential.user!, username, role, cellNumber);
      // Return user object
      Residents user = Residents(
        userID: userCredential.user!.uid,
        name: username,
        email: email,
        role: role,
        deviceId: deviceId ?? 'unknown_device',
        profilePictureUrl: '',
        rating: 0.0,
        registrationDate: DateTime.now(),
        lastActive: DateTime.now(),
        cellNumber: cellNumber,
        accountInfo: AccountInfo(
          accountNumber: '',
          balance: 0.0,
          cardInfo: CardInfo(
            cardNumber: '',
            cardExpiry: '',
            cardCSV: 0,
            pin: '',
          ),
        ),
        rewardPoints: 0,
        wardId: '',
        streetAddress: 'Default Street Address',
        suburb: 'Default Suburb',
        city: 'Default City',
        province: 'Default Province',
        postalCode: 'Default Postal Code',
        residentialDocumentUrl: 'Default URL',

        isLoggedIn: false, // Add required field
        fcmToken: '', // Add required field
      );

      return user;
    } on FirebaseAuthException catch (e) {
      print('Error signing up: ${e.message}');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Unique device ID on Android
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor; // Unique device ID on iOS
  }
  return "unknown_device";
}
