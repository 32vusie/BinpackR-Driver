import 'package:flutter/material.dart';
import 'package:binpack_residents/utils/theme.dart'; // Assuming primaryColor is defined here

class LoadingBar extends StatelessWidget {
  final bool isVisible;

  const LoadingBar({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: isVisible
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 4.0,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
