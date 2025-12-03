import 'package:flutter/material.dart';
import 'buy_popup.dart';

class BuyCard extends StatelessWidget {
  final String title;
  final Widget popupContent;

  const BuyCard({super.key, required this.title, required this.popupContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return BuyPopup(title: title, content: popupContent);
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
