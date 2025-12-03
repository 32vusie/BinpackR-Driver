import 'package:flutter/material.dart';
import 'pay_popup.dart';

class PayColumn extends StatelessWidget {
  final IconData icon;
  final String text;
  final String popupTitle;

  const PayColumn({super.key, required this.icon, required this.text, required this.popupTitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PayPopup(title: popupTitle);
            },
          );
        },
        child: Card(
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 48.0,
                ),
                const SizedBox(height: 8.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
