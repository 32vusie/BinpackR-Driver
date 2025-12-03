import 'package:flutter/material.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';

class BusinessesListPage extends StatelessWidget {
  final List<Business> businesses;

  const BusinessesListPage({super.key, required this.businesses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Businesses in Community'),
      ),
      body: ListView.builder(
        itemCount: businesses.length,
        itemBuilder: (context, index) {
          final business = businesses[index];
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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: Image.network(
                  //   business.imageUrl, // Assume Business has an imageUrl field
                  //   width: 60,
                  //   height: 60,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                title: Text(
                  business.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    business.description,
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
                  // Navigate to business details or perform some action
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
