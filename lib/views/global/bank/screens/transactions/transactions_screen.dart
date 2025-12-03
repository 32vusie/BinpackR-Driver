import 'package:binpack_residents/views/global/bank/screens/transactions/widgets/TransactionCard.dart';
import 'package:binpack_residents/views/global/bank/screens/transactions/widgets/TransactionDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  final String userId;

  const TransactionsScreen({super.key, required this.userId});

  // Fetch transactions from Firestore for the current user
  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    final collection = FirebaseFirestore.instance.collection('transactions');
    final querySnapshot =
        await collection.where('residentId', isEqualTo: userId).get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Calculate the total allocated eBins for the transactions
  double _calculateTotalEBins(List<Map<String, dynamic>> transactions) {
    double totalEBins = 0.0;
    for (var transaction in transactions) {
      totalEBins += (transaction['allocatedEBins']?.toDouble() ??
          0.0); // Convert to double
    }
    return totalEBins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Transactions',
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }

          final transactions = snapshot.data!;
          final totalEBins = _calculateTotalEBins(transactions);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total eBins: $totalEBins',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final DateTime date =
                        (transaction['transactionDate'] as Timestamp).toDate();
                    final double allocatedEBins =
                        (transaction['allocatedEBins']?.toDouble() ??
                            0.0); // Convert to double

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailsScreen(
                              date: date,
                              reference: transaction['requestId'] ?? 'Unknown',
                              amount: allocatedEBins,
                              balance:
                                  0.0, // Adjust this value if you have a balance mechanism
                              isReceived: true,
                            ),
                          ),
                        );
                      },
                      child: TransactionCard(
                        date: date,
                        reference: transaction['requestId'] ?? 'Unknown',
                        amount: allocatedEBins,
                        balance:
                            0.0, // Adjust this value if you have a balance mechanism
                        isReceived: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
