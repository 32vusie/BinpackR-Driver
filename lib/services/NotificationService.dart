import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  Future<void> setupFirebaseMessaging(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming message while app is in the foreground
      print('onMessage: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Extract the wasteRequestID or other identifying information
      final wasteRequestID = message.data['wasteRequestID'];
      if (wasteRequestID != null) {
        // Navigate to the waste request details screen with the specific wasteRequestID
        Navigator.of(context).pushNamed('wasteRequestDetails', arguments: wasteRequestID);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Store the FCM token in the Firestore database related to the user
    User? user = _auth.currentUser;
    if (user != null && token != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle notification when app is resumed from the background
    print('onResume: ${message.data}');
  }

  Future<void> sendNotificationToUser(String userId, String message) async {
    final payload = {
      'userId': userId,
      'message': message,
    };

    await sendNotification(payload);
  }

  Future<void> sendNotificationToDriver(String driverId, String message) async {
    final payload = {
      'driverId': driverId,
      'message': message,
    };

    await sendNotification(payload);
  }

  Future<void> sendNotification(Map<String, dynamic> payload) async {
    final url = Uri.parse('http://localhost:3000/send-notification'); // Replace with your endpoint
    final response = await http.post(
      url,
      body: payload,
    );

    if (response.statusCode != 200) {
      print('Failed to send notification: ${response.body}');
    }
  }
}
