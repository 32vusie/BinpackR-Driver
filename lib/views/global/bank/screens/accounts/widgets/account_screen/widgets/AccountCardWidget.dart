import 'package:flutter/material.dart';
import '../../../../../../../../models/users/resident.dart';

class AccountCard extends StatelessWidget {
  final AccountInfo accountInfo;
  final String residentName;

  const AccountCard({
    super.key,
    required this.accountInfo,
    required this.residentName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resident Name',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Name: $residentName',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Account Number: ${accountInfo.accountNumber}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Balance: R ${accountInfo.balance}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Card Number: ${accountInfo.cardInfo.cardNumber}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Card Expiry: ${accountInfo.cardInfo.cardExpiry}',
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



// import 'package:flutter/material.dart';

// class AccountCardWidget extends StatelessWidget {
//   final String accountNumber;
//   final double balance;
//   final String accountType;

//   AccountCardWidget({
//     required this.accountNumber,
//     required this.balance,
//     required this.accountType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Account Number: $accountNumber',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Balance: \$${balance.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Account Type: $accountType',
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
