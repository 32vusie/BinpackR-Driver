import 'package:flutter/material.dart';

class CenteredLogo extends StatelessWidget {
  final String assetPath;

  const CenteredLogo({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        child: Image.asset(assetPath),
      ),
    );
  }
}
