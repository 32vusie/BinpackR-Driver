// Widget to display community name, description, and adopted count
import 'package:flutter/material.dart';

class CommunityInfo extends StatelessWidget {
  final String name;
  final String description;
  final int adoptedCount;

  const CommunityInfo({
    super.key,
    required this.name,
    required this.description,
    required this.adoptedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 10),
        Text(
          'Adopted Count: $adoptedCount',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
