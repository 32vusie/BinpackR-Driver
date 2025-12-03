import 'package:flutter/material.dart';

class EducationalContentScreen extends StatelessWidget {
  final List<String> learningModules = [
    "Recycling Basics",
    "How to Compost Organic Waste",
    "How to Dispose of E-waste"
  ];

   EducationalContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Educational Content")),
      body: ListView.builder(
        itemCount: learningModules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(learningModules[index]),
            leading: const Icon(Icons.school),
          );
        },
      ),
    );
  }
}
