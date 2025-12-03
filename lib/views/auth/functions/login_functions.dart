import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/auth/login_screen/login_screen.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/residents_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Logs in a resident and navigates to their home screen if successful.
///
/// [context]: The current build context.
/// [formKey]: The form key for validation.
/// [emailController]: Controller for the email field.
/// [passwordController]: Controller for the password field.
/// [isNavigating]: Boolean to prevent multiple navigation calls.
///
/// Returns the UID of the logged-in resident or null if an error occurs.
Future<String?> loginUser(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController,
  bool isNavigating,
) async {
  if (formKey.currentState!.validate()) {
    try {
      // Sign in the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Check for logged-in status on another device
      final existingUserQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text.trim())
          .where('isLoggedIn', isEqualTo: true)
          .get();

      if (existingUserQuery.docs.isNotEmpty) {
        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        _showDelinkDialog(context, docRef);
        return null;
      }

      // Fetch resident document
      final residentDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final residentDoc = await residentDocRef.get();

      // Update isLoggedIn status and lastActive timestamp, and navigate to resident home screen
      if (residentDoc.exists) {
        await residentDocRef.update({
          'isLoggedIn': true,
          'lastActive': FieldValue.serverTimestamp(),
        });
        if (!isNavigating) {
          isNavigating = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResidentsHome(
                resident: Residents.fromJson(residentDoc.data()!),
                userId: uid,
              ),
            ),
          );
        }
        return uid;
      } else {
        throw Exception('Resident document not found');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  return null;
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void _showDelinkDialog(BuildContext context, DocumentReference userDocRef) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delink'),
        content: const Text(
          'This feature is for protecting your privacy. Would you like to sign out on all other devices so you can log in on this device?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Update the resident's `isLoggedIn` status
                await userDocRef.update({
                  'isLoggedIn': false,
                  'lastActive': FieldValue.serverTimestamp(),
                });

                // Sign out the current user and navigate to login
                await FirebaseAuth.instance.signOut();

                _showSnackBar(
                  context,
                  'You have been signed out on all devices. Please log in again on this device.',
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } catch (e) {
                _showSnackBar(context, 'Error: ${e.toString()}');
              }
            },
            child: const Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

