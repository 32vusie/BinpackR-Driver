import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final String userId;

  const StatisticsCard({super.key, required this.userId});

  Future<Map<String, dynamic>> _fetchStatsData() async {
    final userRequests = await FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: userId)
        .get();

    final totalRequests = userRequests.size;
    final completedRequests =
        userRequests.docs.where((doc) => doc['status'] == 'collected').length;

    final totalWasteDisposed = userRequests.docs
        .where((doc) => doc['status'] == 'collected')
        .fold<double>(0, (sum, doc) => sum + (doc['weight'] ?? 0))
        .toInt();

    final adoptedCommunitiesSnapshot = await FirebaseFirestore.instance
        .collection('adoptedCommunities')
        .where('userID', isEqualTo: userId)
        .get();
    final adoptedCommunities = adoptedCommunitiesSnapshot.size;

    return {
      'totalRequests': totalRequests,
      'completedRequests': completedRequests,
      'totalWasteDisposed': totalWasteDisposed,
      'adoptedCommunities': adoptedCommunities,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchStatsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading stats: ${snapshot.error}'));
        }

        final stats = snapshot.data!;
        final statsData = [
          {'title': 'Waste Requests', 'value': '${stats['totalRequests']}'},
          {'title': 'Completed Requests', 'value': '${stats['completedRequests']}'},
          {'title': 'Waste Disposed', 'value': '${stats['totalWasteDisposed']} kg'},
          {'title': 'Adopted Communities', 'value': '${stats['adoptedCommunities']}'},
        ];

        return Container(
          decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 83, 139, 20),
                    Color.fromARGB(255, 8, 116, 13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Current User Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: statsData.length,
                itemBuilder: (context, index) {
                  final stat = statsData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stat['title']!, style: const TextStyle(fontSize: 16)),
                          Text(stat['value']!, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
