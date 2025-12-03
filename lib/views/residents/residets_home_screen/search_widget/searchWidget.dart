import 'package:flutter/material.dart';

class ResidentSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode; // Add FocusNode parameter
  final void Function(String) onTextChanged;

  const ResidentSearchBar({
    super.key,
    required this.controller,
    required this.focusNode, // Initialize FocusNode in constructor
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode, // Set FocusNode here
              onChanged: onTextChanged,
              decoration: const InputDecoration(
                hintText: 'Search...',
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            onTextChanged(controller.text);
          },
        ),
      ],
    );
  }
}
