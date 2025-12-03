import 'package:binpack_residents/views/global/bank/screens/accounts/widgets/account_screen/widgets/CardGridWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:binpack_residents/models/users/resident.dart';

class UserDetailsWidget extends StatelessWidget {
  final CollectionReference residentsCollection =
      FirebaseFirestore.instance.collection('users');
  final String userID;

  UserDetailsWidget({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        title: const Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: residentsCollection.doc(userID).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('User data not available.');
                  }

                  final resident = Residents.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);

                  return Column(
                    children: [
                      // Resident Details
                      // const Text(
                      //   'Resident Details',
                      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 10),
                      // Text('Name: ${resident.name}'),
                      // Text('Email: ${resident.email}'),
                      // Text('Role: ${resident.role}'),
                      // Text('Cell Number: ${resident.cellNumber}'),
                      // Text('Rating: ${resident.rating.toStringAsFixed(2)}'),

                      // Account Info Card
                      CreditCardWidget(
                        cardNumber: resident.accountInfo.cardInfo.cardNumber,
                        expiryDate: resident.accountInfo.cardInfo.cardExpiry,
                        cardHolderName:
                            resident.name, // Displaying name as cardholder
                        cvvCode: resident.accountInfo.cardInfo.cardCSV
                            .toString(), // Displaying CVV
                        showBackView: false,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {},
                        bankName: 'eBin Wallet', // Customize the bank name
                        frontCardBorder: Border.all(color: Colors.grey),
                        backCardBorder: Border.all(color: Colors.grey),
                        cardBgColor: const Color.fromARGB(255, 9, 87, 13),
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        // Add other customization options here as needed
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardGrid(resident: resident),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
