import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Community>> fetchCommunities() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('communities').get();
    return snapshot.docs
        .map((doc) => Community.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching communities: $e');
    return []; // Return an empty list on error
  }
}

Future<void> adoptCommunity(String communityID) async {
  DocumentReference communityRef =
      FirebaseFirestore.instance.collection('communities').doc(communityID);
  await communityRef.update({'adoptedCount': FieldValue.increment(1)});
}

Future<void> likePark(String communityID, String parkID) async {
  DocumentReference communityRef =
      FirebaseFirestore.instance.collection('communities').doc(communityID);

  // Fetch current parks
  DocumentSnapshot communitySnapshot = await communityRef.get();
  final communityData = communitySnapshot.data() as Map<String, dynamic>;
  final List parks = communityData['parks'] ?? [];

  // Find the park to update or add a new park if it doesn't exist
  final parkIndex = parks.indexWhere((p) => p['parkID'] == parkID);
  if (parkIndex != -1) {
    parks[parkIndex]['likes'] = (parks[parkIndex]['likes'] ?? 0) + 1;
  } else {
    parks.add({'parkID': parkID, 'likes': 1});
  }

  // Update the parks field in Firestore
  await communityRef.update({'parks': parks});
}

Future<void> writePost(
    String communityID, String userID, String content, String type) async {
  await FirebaseFirestore.instance.collection('posts').add({
    'communityID': communityID,
    'userID': userID,
    'content': content,
    'timestamp': FieldValue.serverTimestamp(),
    'type': type,
    'likes': 0,
  });
}
