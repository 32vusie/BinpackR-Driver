import 'dart:async';
import 'package:binpack_residents/models/users/resident.dart' as user_model;
import 'package:binpack_residents/services/firebase_service.dart';
import 'package:binpack_residents/views/auth/functions/generateBankInfo.dart';
import 'package:binpack_residents/views/auth/login_screen/login_screen.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/residents_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Registers a new resident and navigates to the home screen.
Future<void> registerUser(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController phoneController,
) async {
  if (formKey.currentState == null || !formKey.currentState!.validate()) {
    return;
  }

  final String email = emailController.text.trim();
  final String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showSnackBar(context, 'Email and password cannot be empty.');
    return;
  }

  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new user
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String userId = userCredential.user!.uid;

    // Send email verification
    await userCredential.user!.sendEmailVerification();

    // Create resident
    await _createResident(
        context, firestore, userId, email, phoneController.text.trim());
  } on FirebaseAuthException catch (e) {
    _handleAuthException(context, e);
  } catch (e) {
    debugPrint('Error: $e');
    _showSnackBar(context, 'An unexpected error occurred.');
  }
}

Future<void> _createResident(
  BuildContext context,
  FirebaseFirestore firestore,
  String userId,
  String email,
  String phone,
) async {
  final user_model.Residents resident = user_model.Residents(
    userID: userId,
    name: email,
    email: email,
    role: 'resident',
    profilePictureUrl: '',
    lastActive: DateTime.now(),
    registrationDate: DateTime.now(),
    cellNumber: phone,
    rating: 0.0,
    rewardPoints: 0,
    wardId: '',
    accountInfo: user_model.AccountInfo(
      accountNumber: BankingInfoGenerator.generateAccountNumber(),
      balance: 1000.0,
      cardInfo: user_model.CardInfo(
        cardNumber: BankingInfoGenerator.generateCardNumber(16),
        cardExpiry: BankingInfoGenerator.generateCardExpiry(),
        cardCSV: int.parse(BankingInfoGenerator.generateCardCSV()),
        pin: BankingInfoGenerator.generatePIN(),
      ),
    ),
    streetAddress: '',
    suburb: '',
    city: '',
    province: '',
    postalCode: '',
    residentialDocumentUrl: '',
    isLoggedIn: false,
    fcmToken: '',
    deviceId: getDeviceId().toString(),
  );

  await firestore.collection('users').doc(userId).set(resident.toJson());
  _checkEmailVerification(context);
}

void _handleAuthException(BuildContext context, FirebaseAuthException e) {
  String message;
  switch (e.code) {
    case 'email-already-in-use':
      message = 'The email address is already in use by another account.';
      break;
    case 'invalid-email':
      message = 'The email address is not valid.';
      break;
    case 'weak-password':
      message = 'The password is too weak.';
      break;
    default:
      message = 'Registration failed. ${e.message}';
  }
  _showSnackBar(context, message);
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _checkEmailVerification(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  await user?.reload();
  if (user != null && user.emailVerified) {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final user_model.Residents resident =
          user_model.Residents.fromSnapshot(userDoc);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResidentsHome(resident: resident, userId: user.uid),
        ),
      );
    } else {
      _showSnackBar(context, 'Resident data not found.');
    }
  } else {
    _showVerificationDialog(context);
  }
}

void _showVerificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Verify Your Email'),
        content: const Text(
          'Please verify your email by clicking the link sent to your inbox. Once verified, press the button below to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final User? user = FirebaseAuth.instance.currentUser;
              if (user != null && !user.emailVerified) {
                await user.sendEmailVerification();
                _showSnackBar(
                  context,
                  'Verification email sent. Please check your inbox.',
                );
              }
            },
            child: const Text('Resend Email'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      );
    },
  );
}