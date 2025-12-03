// Widgets for Logo and Slogan
import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double logoSize;
  const LogoWidget({super.key, required this.logoSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Image.asset(
        'assets/images/accesnts/logo-binpack-r.png',
      ),
    );
  }
}

class SloganWidget extends StatelessWidget {
  const SloganWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'A CLEAN START',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.normal, color: primaryColor),
    );
  }
}
