import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_card.dart';

class TransactionList extends StatefulWidget {
  final String userId; // Add user's ID as a required parameter

  const TransactionList({super.key, required this.userId});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('transactions') // Assuming your transactions are stored in a 'transactions' collection
          .where('userId', isEqualTo: widget.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return TransactionCard(
              date: (data['date'] as Timestamp).toDate(),
              reference: data['reference'],
              accountNumber: data['accountNumber'],
              amount: data['amount'].toDouble(),
            );
          }).toList(),
        );
      },
    );
  }
}
