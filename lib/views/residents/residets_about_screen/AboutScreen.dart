import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Company',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Binpackr is a forward-thinking waste management platform focused on environmental sustainability. Our mission is to facilitate easy and effective recycling by connecting drivers and residents. By rewarding users for eco-friendly efforts, we aim to make a positive impact on the environment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Mission',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our mission is to provide a seamless solution for waste management that encourages recycling through incentives. We aim to create a sustainable environment by integrating modern technology to reduce waste, track collection, and promote eco-friendly practices.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '• Driver and Resident Connectivity: Connects users and drivers for seamless waste collection.\n'
              '• Rewards System: Incentivizes users to recycle with rewards for responsible waste disposal.\n'
              '• Educational Content: Provides resources on waste management, recycling practices, and sustainability.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Values',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '• Sustainability: Committed to reducing environmental impact through effective waste management.\n'
              '• Innovation: Leveraging technology to streamline recycling processes.\n'
              '• Community: Building a network of users who care about the environment and sustainable practices.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email: info@binpackr.com\nPhone: +123 456 7890\nAddress: 123 Eco Street, Green City, Country',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to contact form or email launch logic
                },
                child: const Text('Contact Us Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
