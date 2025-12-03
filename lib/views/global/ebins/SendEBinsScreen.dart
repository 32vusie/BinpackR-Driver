import 'package:flutter/material.dart';

class SendEBinsScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  SendEBinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send eBins')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation cards section
            Expanded(
              child: ListView(
                children: [
                  _buildExplanationCard(
                    context,
                    'Step 1: Enter Amount',
                    'Input the amount of eBins you want to send. Make sure it is a valid number.',
                  ),
                  _buildExplanationCard(
                    context,
                    'Step 2: Verify Recipient',
                    'Ensure you have selected the correct recipient to send your eBins to.',
                  ),
                  _buildExplanationCard(
                    context,
                    'Step 3: Confirm Transaction',
                    'Review the amount and recipient details, then click "Send eBins" to proceed.',
                  ),
                  _buildExplanationCard(
                    context,
                    'Step 4: Transaction Successful',
                    'You will receive a confirmation message once the transaction is successful.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount to send'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(_amountController.text) ?? 0;
                await sendEBins(context, amount);
              },
              child: const Text('Send eBins'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context, String title, String description) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> sendEBins(BuildContext context, double amount) async {
  // Logic to handle sending eBins, e.g., update recipient's balance
  // You will need to implement the recipient's user ID selection.
}
