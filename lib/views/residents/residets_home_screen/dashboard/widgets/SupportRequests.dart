import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupportRequests extends StatelessWidget {
  final String userId;

  const SupportRequests({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Support Requests',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('support')
                .where('userID', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No support requests found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  final email = data['email'] ?? 'N/A';
                  final message = data['message'] ?? 'No message provided';
                  final name = data['name'] ?? 'Anonymous';
                  final relatedSupport = data['relatedSupport'] ?? 'General';
                  final supportID = data['supportID'] ?? 'Unknown ID';
                  final date = data['date'] != null
                      ? (data['date'] as Timestamp).toDate()
                      : null;

                  return ListTile(
                    title: Text('$relatedSupport - Support Request'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Message: $message'),
                        const SizedBox(height: 4),
                        Text('Submitted by: $name'),
                        Text('Email: $email'),
                        Text('Support ID: $supportID'),
                        if (date != null)
                          Text('Date: ${DateFormat.yMMMd().format(date)}'),
                      ],
                    ),
                    isThreeLine: true,
                    leading: const Icon(Icons.support_agent, color: Colors.blueAccent),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
