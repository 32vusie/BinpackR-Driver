import 'package:flutter/material.dart';

class SmartRecyclingScreen extends StatelessWidget {
  final List<String> recommendations = [
    "Recycle plastic bottles at Depot A",
    "Dispose glass at Center B",
    "Consider composting organic waste"
  ];

   SmartRecyclingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Recycling Recommendations")),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendations[index]),
            leading: const Icon(Icons.recycling),
          );
        },
      ),
    );
  }
}
