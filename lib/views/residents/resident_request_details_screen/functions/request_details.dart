import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/users/resident.dart';

class RequestDetailsService {
  static final _instance = FirebaseFirestore.instance;

  /// Fetch a document from Firestore
  static Future<DocumentSnapshot> fetchDocument(
      String collection, String docID) async {
    return await _instance.collection(collection).doc(docID).get();
  }

  /// Update a document in Firestore
  static Future<void> updateDocument(
      String collection, String docID, Map<String, dynamic> data) async {
    await _instance.collection(collection).doc(docID).update(data);
  }

  // Fetch a resident by ID
  static Future<Residents?> fetchResident(String userID) async {
    final doc = await fetchDocument('users', userID);
    if (doc.exists) {
      return Residents.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
