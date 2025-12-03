import 'package:flutter/material.dart';

class RouteOptimizationScreen extends StatelessWidget {
  final List<String> optimizedRoute = [
    "Depot A -> Street 1 -> Street 2 -> Center B",
    "Depot C -> Street 5 -> Street 3"
  ];

   RouteOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Optimized Collection Route")),
      body: ListView.builder(
        itemCount: optimizedRoute.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(optimizedRoute[index]),
            leading: const Icon(Icons.route),
          );
        },
      ),
    );
  }
}
