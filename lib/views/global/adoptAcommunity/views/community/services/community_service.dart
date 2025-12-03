import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to check if the community is adopted by the user
  Future<bool> checkIfAdopted(String userId, String communityId) async {
    try {
      final adoptionDoc = await _firestore
          .collection('userAdoptions')
          .doc(userId)
          .collection('adoptedCommunities')
          .doc(communityId)
          .get();

      return adoptionDoc.exists;
    } catch (e) {
      print('Error checking adoption status: $e');
      return false;
    }
  }

  // Method to adopt a community
  Future<void> adoptCommunity(String userId, Community community) async {
    final communityRef =
        _firestore.collection('communities').doc(community.communityID);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(communityRef);
        final currentData = snapshot.data();
        if (currentData != null) {
          final currentCount = currentData['adoptedCount'] as int;

          // Increment adopted count
          transaction.update(communityRef, {
            'adoptedCount': currentCount + 1,
          });

          // Add the community to the user's adopted communities
          final userAdoptionsRef = _firestore
              .collection('userAdoptions')
              .doc(userId)
              .collection('adoptedCommunities')
              .doc(community.communityID);

          // Update user adoptions
          transaction.set(userAdoptionsRef, {
            'adoptedAt': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      print('Error adopting community: $e');
      rethrow;
    }
  }

  // Method to get real-time updates for a specific community document
  Stream<DocumentSnapshot> getCommunityStream(String communityId) {
    return _firestore.collection('communities').doc(communityId).snapshots();
  }
}
