import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/residents_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserVerificationScreen extends StatefulWidget {
  final String userId;

  const UserVerificationScreen(this.userId, {super.key});

  @override
  _UserVerificationScreenState createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends State<UserVerificationScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> _verifyEmailAndLogin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await user.reload();
      if (user.emailVerified) {
        _addResidentDetailsAndNavigate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _addResidentDetailsAndNavigate() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      final userData = userDoc.data();

      if (userData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResidentsHome(
              resident: Residents.fromJson(userData),
              userId: widget.userId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resident data not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please verify your email address. Once verified, click the button below.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyEmailAndLogin,
              child: const Text('Verify Email'),
            ),
          ],
        ),
      ),
    );
  }
}