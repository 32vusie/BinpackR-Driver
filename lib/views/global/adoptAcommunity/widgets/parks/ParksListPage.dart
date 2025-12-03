import 'package:flutter/material.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';

class ParksListPage extends StatelessWidget {
  final List<Park> parks;

  const ParksListPage({super.key, required this.parks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parks in Community'),
      ),
      body: ListView.builder(
        itemCount: parks.length,
        itemBuilder: (context, index) {
          final park = parks[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                // leading: ClipRRect(
                //   borderRadius: BorderRadius.circular(8),
                //   child: Image.network(
                //     park.imageUrl,
                //     width: 60,
                //     height: 60,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                title: Text(
                  park.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    park.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Navigate to park details or perform some action
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
