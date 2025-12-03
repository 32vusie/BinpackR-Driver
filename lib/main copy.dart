import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:binpack_residents/views/global/splash/splashScreen.dart';
import 'package:local_auth/local_auth.dart'; // For biometric authentication

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PermissionHandler(
        child: SplashScreen(),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/requestDetails') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) =>
                RequestDetailsScreen(requestId: args['requestId']),
          );
        }
        return null;
      },
    );
  }
}

class PermissionHandler extends StatefulWidget {
  final Widget child;

  const PermissionHandler({required this.child, super.key});

  @override
  _PermissionHandlerState createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initFCM();
    _checkBiometricAvailability();
  }

  Future<void> _requestPermissions() async {
    try {
      final status = await [
        Permission.location,
        Permission.notification,
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ].request();

      for (var permission in status.entries) {
        print('Permission ${permission.key}: ${permission.value}');
      }

      if (status[Permission.location] != PermissionStatus.granted) {
        print('Location permission is not granted');
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _initFCM() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Received a message while in the foreground: ${message.messageId}');
        if (message.notification != null) {
          print(
              'Message contained a notification: ${message.notification?.title}, ${message.notification?.body}');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification was opened: ${message.messageId}');
        if (context.mounted) {
          Navigator.pushNamed(context, '/requestDetails',
              arguments: {'requestId': message.data['requestId']});
        }
      });

      String? token = await messaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        await FirebaseFirestore.instance
            .collection('userTokens')
            .doc('driverID')
            .set({
          'token': token,
          'userType': 'driver',
        });
      } else {
        print('Unable to retrieve FCM token');
      }
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (_isBiometricAvailable) {
        await _attemptBiometricLogin();
      } else {
        print('Biometric authentication not available.');
      }
    } catch (e) {
      print('Error checking biometric availability: $e');
    }
  }

  Future<void> _attemptBiometricLogin() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate with biometrics to access the app',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SplashScreen()), // Navigate to main app screen on success
        );
      } else {
        print('Biometric authentication failed or cancelled.');
      }
    } catch (e) {
      print('Error during biometric login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;

  const RequestDetailsScreen({required this.requestId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: Center(
        child: Text('Details for request ID: $requestId'),
      ),
    );
  }
}
