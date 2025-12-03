import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Community>> getCommunities() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('communities').get();
    return querySnapshot.docs.map((doc) {
      return Community.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Fetch activities (posts) from the 'activities' field in the 'communities' collection
  Future<List<CommunityActivity>> getPosts() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('communities').get();

    // Extract all posts (activities) from all communities
    List<CommunityActivity> allActivities = [];

    for (var doc in querySnapshot.docs) {
      // Parse each community's activities
      List<dynamic> activitiesJson = doc['activities'] ?? [];

      List<CommunityActivity> activities = activitiesJson.map((activityJson) {
        return CommunityActivity.fromJson(activityJson as Map<String, dynamic>);
      }).toList();

      // Add these activities to the global list
      allActivities.addAll(activities);
    }

    return allActivities;
  }
}
