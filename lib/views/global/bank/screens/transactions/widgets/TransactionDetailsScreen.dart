import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final DateTime date;
  final String reference;
  final double amount;
  final double balance;
  final bool isReceived;

  const TransactionDetailsScreen({super.key, 
    required this.date,
    required this.reference,
    required this.amount,
    required this.balance,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat.yMd().format(date)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Reference: $reference',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Amount: ${isReceived ? '+' : '-'} B${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.0,
                color: isReceived
                    ? const Color.fromARGB(255, 8, 116, 13)
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Balance: R${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
