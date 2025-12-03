import 'package:binpack_residents/models/adoptAcommunity.dart';
import '../functions.dart';
import 'package:flutter/material.dart';

class CommunityDetailsScreen extends StatelessWidget {
  final Community community;

  const CommunityDetailsScreen({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(community.name)),
      body: Column(
        children: [
          const Text('Parks'),
          Expanded(
            child: ListView.builder(
              itemCount: community.parks.length,
              itemBuilder: (context, index) {
                final park = community.parks[index];
                return ListTile(
                  title: Text(park.name),
                  subtitle: Text('${park.likes} likes'),
                  trailing: IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {
                      likePark(community.communityID, park.parkID);
                    },
                  ),
                );
              },
            ),
          ),
          const Text('Businesses'),
          Expanded(
            child: ListView.builder(
              itemCount: community.businesses.length,
              itemBuilder: (context, index) {
                final business = community.businesses[index];
                return ListTile(
                  title: Text(business.name),
                  subtitle: Text(business.businessId),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adoptCommunity(community.communityID),
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
