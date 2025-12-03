// Widget to display the community image or placeholder
import 'package:flutter/material.dart';

class CommunityImage extends StatelessWidget {
  final String? imageUrl;

  const CommunityImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Image.network(imageUrl!)
        : Container(
            height: 200,
            color: Colors.grey[300],
          );
  }
}