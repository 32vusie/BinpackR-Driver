import 'package:binpack_residents/views/global/ebins/ebinsModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eBinsCalculator {
  static int calculateEBins(
    int collectionRequests,
    int segregatedRequests,
    int referrals,
    int completedEducationModules,
    bool isConsistent, {
    int weight = 0, // Optional weight parameter, defaults to 0
  }) {
    const int pointsPerCollection = 10;
    const int pointsPerSegregation = 5;
    const int pointsPerReferral = 20;
    const int pointsPerEducationModule = 15;
    const int consistencyBonus = 50;
    const int weightBonusPerKg = 2; // Points per kg of waste

    int eBins = (collectionRequests * pointsPerCollection) +
        (segregatedRequests * pointsPerSegregation) +
        (referrals * pointsPerReferral) +
        (completedEducationModules * pointsPerEducationModule) +
        (weight * weightBonusPerKg); // Add bonus for waste weight

    if (isConsistent) {
      eBins += consistencyBonus;
    }

    return eBins;
  }

  static Future<void> updateUserEBins(String userID, int newEBins) async {
    final userRef = FirebaseFirestore.instance.collection('eBins').doc(userID);
    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Update existing user eBins
      final existingEBins = eBins.fromSnapshot(userSnapshot);
      await userRef.update({
        'totalEBins': existingEBins.totalEBins + newEBins,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      // Create new eBins entry for the user
      await userRef.set({
        'userID': userID,
        'totalEBins': newEBins,
        'lastUpdated': DateTime.now(),
      });
    }
  }
}
