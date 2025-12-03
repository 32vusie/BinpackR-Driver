import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../models/users/resident.dart';

Future<void> updateAccountBalance(String userId, double newBalance) async {
  try {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Update the account balance in Firebase
    await usersCollection
        .doc(userId)
        .update({'accountInfo.balance': newBalance});

    print('Account balance updated successfully.');
  } catch (error) {
    // Handle any exceptions or errors here
    print('Error updating account balance: $error');
  }
}

Future<void> sendMoney(
  BuildContext context,
  double amount,
  Residents sender,
  String receiverAccountNumber,
) async {
  try {
    // Assuming you have a method to check account balance
    print("Passed Account Number: $receiverAccountNumber");
    if (sender.accountInfo.balance >= amount) {
      // Find the receiver based on the account number
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accounts', arrayContains: {'accountNumber': receiverAccountNumber})
          .get();
      print("Found Account Number: $receiverAccountNumber");

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot receiverDoc = querySnapshot.docs.first;

        // Find the correct accountInfo in the array
        final List<dynamic> accounts = receiverDoc['accounts'];
        final Map<String, dynamic> accountInfoMap = accounts.firstWhere(
          (account) => account['accountNumber'] == receiverAccountNumber,
          orElse: () => <String, dynamic>{},
        );

        if (accountInfoMap.isNotEmpty) {
          // Print information about the match
          print('Match found for account number: $receiverAccountNumber');
          print('Sending amount: $amount');
          print('Original balance in receiver\'s account: ${accountInfoMap['balance']}');

          // Update the receiver's account balance in Firebase
          await updateAccountBalance(
              receiverDoc.id, accountInfoMap['balance'] + amount);

          // Update the sender's account balance in Firebase
          await updateAccountBalance(
              sender.userID, sender.accountInfo.balance - amount);

          // Print the remaining balance after the amount has been sent
          print('Remaining balance in sender\'s account: ${sender.accountInfo.balance - amount}');

          // Simulate successful money transfer
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Money sent successfully!'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          ).then((value) {
            // Handle dialog result here if needed
          });
        } else {
          // Show error dialog for invalid receiver account number
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Invalid receiver account number.'),
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
        // Show error dialog for invalid receiver account number
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Invalid receiver account number.'),
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
      // Show error dialog for insufficient balance
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Insufficient balance.'),
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
  } catch (error) {
    // Handle any exceptions or errors here
    print('Error sending money: $error');
  }
}




