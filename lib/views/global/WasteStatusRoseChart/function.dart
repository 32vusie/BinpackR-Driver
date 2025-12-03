import 'package:binpack_residents/models/waste_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, double>> getTopUsersData() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('wasteCollectionRequests')
      .get();

  final Map<String, double> userRequestCounts = {};

  for (var doc in querySnapshot.docs) {
    final request = WasteCollectionRequest.fromFirestore(doc);

    if (userRequestCounts.containsKey(request.userID)) {
      userRequestCounts[request.userID] =
          userRequestCounts[request.userID]! + 1;
    } else {
      userRequestCounts[request.userID] = 1;
    }
  }

  // Sort and get top 6 users
  final sortedEntries = userRequestCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final topUsers = Map.fromEntries(sortedEntries.take(6));

  return topUsers;
}
