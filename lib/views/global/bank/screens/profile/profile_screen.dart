import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 8, 116, 13),
          ),
        ),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: const Center(
        child: Text('User Profile'),
      ),
    );
  }
}
