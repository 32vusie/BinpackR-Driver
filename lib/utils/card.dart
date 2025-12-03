import 'package:binpack_residents/utils/globalPadding.dart';
import 'package:flutter/material.dart';

// Card widget
class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: GlobalPadding.small,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(padding: GlobalPadding.all, child: child),
    );
  }
}

// Card list
class CardList extends StatelessWidget {
  final List<Widget> cards;

  const CardList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) => CustomCard(child: cards[index]),
    );
  }
}
