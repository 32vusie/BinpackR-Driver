import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/users/resident.dart';

class AccountSearchScreen extends StatefulWidget {
  final Residents resident;

  const AccountSearchScreen({super.key, required this.resident});

  @override
  _AccountSearchScreenState createState() => _AccountSearchScreenState();
}

class _AccountSearchScreenState extends State<AccountSearchScreen> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  String searchResult = '';
  List<Map<String, dynamic>> allAccounts = [];

  Future<void> searchAccount() async {
    // Trim whitespaces from the entered account number
    final String accountNumber = accountNumberController.text.trim();

    try {
      // Search for all users in the users collection
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Clear previous search results
        setState(() {
          searchResult = '';
          allAccounts = [];
        });

        // Iterate through all users
        for (final QueryDocumentSnapshot userDoc in querySnapshot.docs) {
          final List<dynamic> accounts = userDoc['accounts'];

          // Find the accountInfo in the array
          final Map<String, dynamic> accountInfoMap = accounts.firstWhere(
            (account) => account['accountNumber'].toString() == accountNumber,
            orElse: () => <String, dynamic>{},
          );

          // Display the name associated with the account number
          if (accountInfoMap.isNotEmpty) {
            setState(() {
              searchResult +=
                  'Name: ${userDoc['name']}\nBalance: ${accountInfoMap['balance']}\n\n';
            });

            // Add the account details to the list
            allAccounts.add(accountInfoMap);
          }
        }

        // Print all accounts for testing
        print('All Accounts: $allAccounts');
      } else {
        // No users found
        setState(() {
          searchResult = 'No users found.';
          allAccounts = [];
        });
      }
    } catch (error) {
      // Handle any exceptions or errors here
      print('Error searching accounts: $error');
      setState(() {
        searchResult = 'Error searching accounts.';
        allAccounts = [];
      });
    }
  }

  Future<void> sendAmount(Map<String, dynamic> targetAccount) async {
    final double amount = double.tryParse(amountController.text) ?? 0.0;

    // Show PIN entry dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter 4-digit PIN'),
          content: TextField(
            controller: pinController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validate PIN and send amount
                if (validatePIN(pinController.text)) {
                  await sendMoney(targetAccount, amount);
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  // Incorrect PIN
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect PIN. Try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  pinController.clear(); // Clear the incorrect PIN
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  bool validatePIN(String enteredPIN) {
    // Validate the entered PIN against the resident's actual PIN
    return enteredPIN == widget.resident.accountInfo.cardInfo.pin;
  }

  Future<void> sendMoney(
      Map<String, dynamic> targetAccount, double amount) async {
    // Implement the logic to send money here
    // Deduct amount from the sender's account
    final List<dynamic> senderAccounts =
        widget.resident.accountInfo.accountNumber as List;
    final int senderIndex = senderAccounts.indexWhere((account) =>
        account['accountNumber'] == targetAccount['accountNumber']);

    if (senderIndex != -1) {
      senderAccounts[senderIndex]['balance'] -= amount;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.resident.userID)
          .update({
        'accounts': senderAccounts,
      });

      // Add amount to the target account
      final List<dynamic> targetAccounts = targetAccount['accounts'];
      final int targetIndex = targetAccounts.indexWhere(
        (account) =>
            account['accountNumber'] ==
            senderAccounts[senderIndex]['accountNumber'],
      );

      if (targetIndex != -1) {
        targetAccounts[targetIndex]['balance'] += amount;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(targetAccount['userID'])
            .update({
          'accounts': targetAccounts,
        });

        // Update the UI
        setState(() {
          searchResult = '';
          allAccounts = [];
        });
        accountNumberController.clear();
        amountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Amount sent successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Account Information:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Name: ${widget.resident.name}\nBalance: ${widget.resident.accountInfo.balance}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Enter Account Number',
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await searchAccount();
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Search Result: $searchResult',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'All Accounts:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allAccounts.length,
                itemBuilder: (context, index) {
                  final account = allAccounts[index];
                  return ListTile(
                    title: Text('Account Number: ${account['accountNumber']}'),
                    subtitle: Text('Balance: ${account['balance']}'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await sendAmount(account);
                      },
                      child: const Text('Send Amount'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
