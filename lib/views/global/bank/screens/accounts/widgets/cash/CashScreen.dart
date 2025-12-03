import 'package:flutter/material.dart';

class CashScreen extends StatelessWidget {
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        title: const Text('Cash'),
      ),
      body: const Center(
        child: Text('Cash Screen'),
      ),
    );
  }
}
