
import 'package:cloud_firestore/cloud_firestore.dart';

class eBins {
  final String userID;
  final int totalEBins;
  final DateTime lastUpdated;

  eBins({
    required this.userID,
    required this.totalEBins,
    required this.lastUpdated,
  });

  factory eBins.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return eBins(
      userID: data['userID'] ?? '',
      totalEBins: data['totalEBins'] ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'totalEBins': totalEBins,
        'lastUpdated': lastUpdated,
      };
}
