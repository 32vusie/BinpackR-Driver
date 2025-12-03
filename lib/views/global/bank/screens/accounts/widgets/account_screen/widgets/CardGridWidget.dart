import 'package:flutter/material.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/account_screen/widgets/ActionCardWidget.dart';
import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/buy/BuyScreen.dart';
import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/cash/CashScreen.dart';
import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/pay/PayScreen.dart';

import '../../send/functions/accountSearch.dart';

class CardGrid extends StatelessWidget {
  final Residents resident;

  const CardGrid({
    super.key,
    required this.resident,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountSearchScreen(
                  resident: resident,
                ),
              ),
            );
          },
          child: const ActionCard(
            image:
                'assets/bank_images_onbording/Wallet-amico.png', // Replace with your send icon image path
            text: 'Send',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BuyScreen()),
            );
          },
          child: const ActionCard(
            image:
                'assets/bank_images_onbording/Finance app-rafiki.png', // Replace with your buy icon image path
            text: 'Buy',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PayScreen(userId: 'currentUser.id'),
            ));
          },
          child: const ActionCard(
            image:
                'assets/bank_images_onbording/Scan to pay-amico.png', // Replace with your pay icon image path
            text: 'Pay',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CashScreen()),
            );
          },
          child: const ActionCard(
            image:
                'assets/bank_images_onbording/ATM machine-amico.png', // Replace with your cash icon image path
            text: 'Cash',
          ),
        ),
      ],
    );
  }
}
