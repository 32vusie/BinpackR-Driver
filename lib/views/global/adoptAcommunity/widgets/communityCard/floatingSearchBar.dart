import 'package:flutter/material.dart';

class FloatingSearchBar extends StatelessWidget {
  final String searchTerm;
  final ValueChanged<String> onSearchChanged;

  const FloatingSearchBar({super.key, 
    required this.searchTerm,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Communities',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
