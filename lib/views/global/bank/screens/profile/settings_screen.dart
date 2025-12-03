import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromARGB(255, 8, 116, 13),
          ),
        ),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: const Center(
        child: Text('Account Settings'),
      ),
    );
  }
}
