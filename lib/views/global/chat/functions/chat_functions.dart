import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:binpack_residents/models/users/driver.dart';
import 'package:binpack_residents/models/users/resident.dart';

class ChatFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markMessagesAsRead(String wasteRequestId) async {
    String currentUserID = _auth.currentUser!.uid;

    try {
      QuerySnapshot<Map<String, dynamic>> unreadMessages = await _firestore
          .collection('chats')
          .doc(wasteRequestId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('sender', isNotEqualTo: currentUserID)
          .get();

      List<DocumentReference> unreadMessageReferences =
          unreadMessages.docs.map((doc) => doc.reference).toList();

      // Batch update to mark messages as read
      WriteBatch batch = _firestore.batch();
      for (var ref in unreadMessageReferences) {
        batch.update(ref, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<Driver> fetchDriverData(String driverID) async {
    try {
      DocumentSnapshot driverSnapshot =
          await _firestore.collection('drivers').doc(driverID).get();

      if (driverSnapshot.exists) {
        // Driver data found
        Map<String, dynamic> driverData =
            driverSnapshot.data() as Map<String, dynamic>;
        return Driver.fromJson(driverData);
      } else {
        // Driver not found
        throw Exception('Driver not found');
      }
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore errors)
      throw Exception('Error fetching driver data: $e');
    }
  }

  Future<Residents> fetchUserData(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(userID).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        return Residents.fromJson(userData);
      } else {
        // Handle user not found
        throw Exception("User not found");
      }
    } catch (e) {
      // Handle errors, e.g., network errors, etc.
      print("Error fetching user data: $e");
      throw Exception("Error fetching user data");
    }
  }
}
