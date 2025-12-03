import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RewardsProgress extends StatelessWidget {
  final String userId;

  const RewardsProgress({required this.userId, super.key});

  int _calculateTotalEBins(List<QueryDocumentSnapshot> transactions) {
    return transactions.fold<int>(0, (total, doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return total + (data['allocatedEBins'] as int? ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('residentId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No eBins transactions found.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // Calculate total eBins from the transaction data
        final int totalEBins = _calculateTotalEBins(snapshot.data!.docs);
        const int rewardThreshold = 100;

        // Calculate remaining eBins for the next milestone
        final int progressToNextReward = rewardThreshold - (totalEBins % rewardThreshold);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'eBins Balance & Rewards Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(
                  value: ((totalEBins % rewardThreshold) / rewardThreshold).toDouble(),
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text('eBins: $totalEBins'),
                Text('Next reward in $progressToNextReward eBins'),
              ],
            ),
          ),
        );
      },
    );
  }
}
