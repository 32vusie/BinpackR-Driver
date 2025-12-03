import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  static Future<void> createSupportTicket({
    required String userId,
    required String name,
    required String email,
    required String message,
    required String relatedSupport,
  }) async {
    await FirebaseFirestore.instance.collection('support').add({
      'name': name,
      'email': email,
      'message': message,
      'userID': userId,
      'supportID': DateTime.now().millisecondsSinceEpoch.toString(),
      'relatedSupport': relatedSupport,
      'status': 'open',
      'assignedTo': null,
    });
  }

  static Stream<QuerySnapshot> getSupportTickets(String userId) {
  print("Fetching support tickets for user: $userId");
  return FirebaseFirestore.instance
      .collection('support')
      .where('userID', isEqualTo: userId)
      .orderBy('supportID', descending: true)
      .snapshots()
      .handleError((error) {
    print("Error in Firestore query: $error");
  });
}

}
