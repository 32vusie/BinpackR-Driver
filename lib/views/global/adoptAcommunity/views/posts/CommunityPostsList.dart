// Widget to display the list of community posts
import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:flutter/material.dart';

class CommunityPostsList extends StatelessWidget {
  final List<CommunityActivity> activities;

  const CommunityPostsList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: activity.createdAt != null
                ? Text(
                    '${activity.createdAt!.day}/${activity.createdAt!.month}/${activity.createdAt!.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : null,
            title: Text(
              activity.activityType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(activity.content),
            trailing: const Icon(Icons.thumb_up),
          ),
        );
      },
    );
  }
}
