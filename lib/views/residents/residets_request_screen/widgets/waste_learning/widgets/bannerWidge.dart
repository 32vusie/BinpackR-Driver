import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl;
  final String heading;
  final String paragraph;
  final VoidCallback onLearnMore;

  const BannerWidget({super.key, 
    required this.imageUrl,
    required this.heading,
    required this.paragraph,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(heading, style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(paragraph, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
          ),
          ElevatedButton(
            onPressed: onLearnMore,
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}
