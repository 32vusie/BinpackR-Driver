// Layout Widgets
import 'package:binpack_residents/views/auth/login_screen/widgets/logo_slogand.dart';
import 'package:flutter/material.dart';

class SingleColumnLayout extends StatelessWidget {
  final double logoSize;
  final Widget Function() buildForm;

  const SingleColumnLayout(
      {super.key, required this.logoSize, required this.buildForm});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LogoWidget(logoSize: logoSize),
        const SizedBox(height: 24),
        const SloganWidget(),
        const SizedBox(height: 24),
        buildForm(),
      ],
    );
  }
}

class TwoColumnLayout extends StatelessWidget {
  final double logoSize;
  final Widget Function() buildForm;

  const TwoColumnLayout(
      {super.key, required this.logoSize, required this.buildForm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(logoSize: logoSize),
              const SizedBox(height: 32),
              const SloganWidget(),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to BinpackR',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please log in to continue managing your waste collection activities effectively.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                buildForm(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
