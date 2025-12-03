import 'package:binpack_residents/models/users/resident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void saveChanges(
  BuildContext context,
  Residents resident,
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController cellNumberController,
) async {
  String newName = nameController.text;
  String newEmail = emailController.text;
  String newCellNumber = cellNumberController.text;

  Residents updatedResident = Residents(
    userID: resident.userID,
    name: newName,
    email: newEmail,
    role: resident.role,
    deviceId: resident.deviceId,
    profilePictureUrl: resident.profilePictureUrl,
    lastActive: resident.lastActive,
    registrationDate: resident.registrationDate,
    cellNumber: newCellNumber,
    rating: resident.rating,
    rewardPoints: resident.rewardPoints,
    wardId: resident.wardId,
    accountInfo: resident.accountInfo,
    streetAddress: resident.streetAddress,
    suburb: resident.suburb,
    city: resident.city,
    province: resident.province,
    postalCode: resident.postalCode,
    residentialDocumentUrl: resident.residentialDocumentUrl,
    isLoggedIn: resident.isLoggedIn, // Add required field
    fcmToken: resident.fcmToken, // Add required field
  );

  // Update the resident's data in Firestore
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(resident.userID)
        .update(updatedResident.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully.'),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save changes.'),
      ),
    );
    print('Error updating resident: $error');
  }
}
