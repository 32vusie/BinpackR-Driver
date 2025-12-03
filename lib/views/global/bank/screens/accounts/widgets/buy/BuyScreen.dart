import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/buy/widgets/card_list.dart';
import 'package:flutter/material.dart';

import 'widgets/buy_card.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        title: const Text('Buy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          BuyCard(
            title: 'Mobile',
            popupContent: Column(
              children: [
                CardList(title: 'Airtime', items: ['Vadacom', 'MTN', 'CellC']),
                CardList(
                    title: 'Data Bundles', items: ['Vadacom', 'MTN', 'CellC']),
                CardList(
                    title: 'SMS Bundles', items: ['Vadacom', 'MTN', 'CellC']),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          BuyCard(
            title: 'Electricity',
            popupContent: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Meta Number'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          BuyCard(
            title: 'Water',
            popupContent: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Meta Number'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
