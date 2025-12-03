import 'package:binpack_residents/views/global/bank/screens/logic/bankFunctions.dart';
import 'package:flutter/material.dart';

import 'widgets/pay_column.dart';
import 'widgets/transaction_list.dart';

class PayScreen extends StatefulWidget {
  final String userId; // Accepting userId as a parameter
  const PayScreen({super.key, required this.userId});

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BankingService bankingService = BankingService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        title: const Text('Pay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PayColumn(
                  icon: Icons.qr_code_scanner,
                  text: 'Scan to Pay',
                  popupTitle: 'Send QR Scanner',
                ),
                PayColumn(
                  icon: Icons.qr_code,
                  text: 'PayMe',
                  popupTitle: 'Receive QR Code',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 8, 116, 13),
              tabs: const [
                Tab(
                  child: Text(
                    'ScanPay',
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 116, 13),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'PayMe',
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 116, 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TransactionList(
                      userId:
                          widget.userId), // Passing userId to TransactionList
                  TransactionList(
                      userId:
                          widget.userId), // Passing userId to TransactionList
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
