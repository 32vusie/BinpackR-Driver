import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String image; // Change the type to String for the image path
  final String text;

  const ActionCard({super.key, 
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image, // Use the image path
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
