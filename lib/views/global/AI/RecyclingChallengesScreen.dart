import 'package:flutter/material.dart';

class RecyclingChallengesScreen extends StatelessWidget {
  final List<String> challenges = [
    "Recycle 5 kg of plastic this week",
    "Compost 2 kg of organic waste",
    "Collect and dispose of 3 e-waste items"
  ];

   RecyclingChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recycling Challenges")),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(challenges[index]),
            leading: const Icon(Icons.assignment),
          );
        },
      ),
    );
  }
}
