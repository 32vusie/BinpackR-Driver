// Widget for navigating to Parks and Businesses
import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:flutter/material.dart';

class CommunityActions extends StatelessWidget {
  final Community community;
  final VoidCallback onNavigateToParks;
  final VoidCallback onNavigateToBusinesses;

  const CommunityActions({
    super.key,
    required this.community,
    required this.onNavigateToParks,
    required this.onNavigateToBusinesses,
  });

  Widget customButton(
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 34, 105, 3),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: customButton(
            label: 'Parks',
            onPressed: onNavigateToParks,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: customButton(
            label: 'Businesses',
            onPressed: onNavigateToBusinesses,
          ),
        ),
      ],
    );
  }
}
