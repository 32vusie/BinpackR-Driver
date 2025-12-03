import 'package:flutter/material.dart';
import 'package:binpack_residents/models/users/resident.dart';

import 'functions/SendCash.dart';

class SendScreen extends StatelessWidget {
  final Residents resident;
  // final BankFunctions bankingService = BankFunctions();

  SendScreen({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        title: const Text('Send'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          sendCard(context),
        ],
      ),
    );
  }

  Widget sendCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return sendPopup(context, resident);
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                'assets/bank_images_onbording/Wallet-amico.png',
                width: 48.0,
                height: 48.0,
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send to User',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    'Balance: ${resident.accountInfo.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController accountNumberController = TextEditingController();

  Widget sendPopup(BuildContext context, Residents resident) {
    TextEditingController amountController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance: ${resident.accountInfo.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Receiver Account Number',
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;

                    if (amount > 0) {
                      // Debug prints
                      print(
                          'Entered Account Number: ${accountNumberController.text}');

                      // Check if entered account number matches any resident's account number
                      if (accountNumberController.text !=
                          resident.accountInfo.accountNumber) {
                        try {
                          // TODO: Implement your logic to handle sending money
                          await sendMoney(context, amount, resident,
                              accountNumberController.text);
                        } catch (error) {
                          print('Error sending money: $error');
                        }
                      } else {
                        // Show error if entered account number matches sender's account number
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Cannot send money to your own account.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // Show error if input is invalid
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Invalid input.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
