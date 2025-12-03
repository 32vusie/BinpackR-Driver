import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityEngagement extends StatelessWidget {
  final String? communityId; // Allow nullable communityId

  const CommunityEngagement({required this.communityId, super.key});

  @override
  Widget build(BuildContext context) {
    if (communityId == null || communityId!.isEmpty) {
      return const Center(child: Text('Community ID is required to load data.'));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Community Engagement',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
            .doc(communityId)
            .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data?.data() == null) {
                  return const Center(child: Text('No community data available.'));
                }

                Map<String, dynamic> communityData = snapshot.data!.data() as Map<String, dynamic>;

                List activities = communityData['activities'] ?? [];
                List businesses = communityData['businesses'] ?? [];
                List parks = communityData['parks'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text('Neighborhood Impact', style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      'Your neighborhood has ${activities.length} recent activities this month.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Divider(),
                    Text('Leaderboard', style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      'You are among the top 10 recyclers!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Divider(),
                    Text('Community Activities', style: Theme.of(context).textTheme.titleSmall),
                    for (var activity in activities.take(3))
                      ListTile(
                        leading: activity['imageUrl'] != null
                            ? Image.network(activity['imageUrl'], width: 40, height: 40, fit: BoxFit.cover)
                            : const Icon(Icons.event),
                        title: Text(activity['title'] ?? 'Activity'),
                        subtitle: Text(activity['content'] ?? ''),
                      ),
                    const Divider(),
                    Text('Local Businesses', style: Theme.of(context).textTheme.titleSmall),
                    for (var business in businesses.take(3))
                      ListTile(
                        leading: business['businessImage'] != null && business['businessImage'] != ""
                            ? Image.network(business['businessImage'], width: 40, height: 40, fit: BoxFit.cover)
                            : const Icon(Icons.business),
                        title: Text(business['name'] ?? 'Business'),
                        subtitle: Text(business['description'] ?? 'No description'),
                      ),
                    const Divider(),
                    Text('Nearby Parks', style: Theme.of(context).textTheme.titleSmall),
                    for (var park in parks.take(2))
                      ListTile(
                        leading: park['imageUrl'] != null && park['imageUrl'] != ""
                            ? Image.network(park['imageUrl'], width: 40, height: 40, fit: BoxFit.cover)
                            : const Icon(Icons.park),
                        title: Text(park['name'] ?? 'Park'),
                        subtitle: Text(park['description'] ?? 'No description'),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
