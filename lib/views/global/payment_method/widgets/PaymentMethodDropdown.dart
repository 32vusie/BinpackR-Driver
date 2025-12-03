// payment_method_screen.dart

import 'package:binpack_residents/views/global/payment_method/widgets/AddPaymentMethodScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Function(
          String paymentMethodId, String cardHolderName, String last4Digits)
      onSelect;

  const PaymentMethodScreen({required this.onSelect, super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late Future<List<Map<String, dynamic>>> _paymentMethodsFuture;

  @override
  void initState() {
    super.initState();
    _paymentMethodsFuture = _fetchPaymentMethods();
  }

  Future<List<Map<String, dynamic>>> _fetchPaymentMethods() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('paymentMethods')
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<void> _refreshPaymentMethods() async {
    setState(() {
      _paymentMethodsFuture = _fetchPaymentMethods();
    });
  }

  Future<void> _deletePaymentMethod(String paymentMethodId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('paymentMethods')
        .doc(paymentMethodId)
        .delete();

    _refreshPaymentMethods();
  }

  void _navigateToAddPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentMethodScreen()),
    ).then((_) => _refreshPaymentMethods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _paymentMethodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching payment methods'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No payment methods saved'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Payment Method'),
                    onPressed: _navigateToAddPaymentMethod,
                  ),
                ],
              ),
            );
          }

          final paymentMethods = snapshot.data!;
          return ListView.builder(
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              return ListTile(
                title: Text(
                  '${method['cardHolderName']} - Card ending in ${method['cardNumber'].substring(method['cardNumber'].length - 4)}',
                ),
                subtitle: Text('Expires on ${method['expiryDate']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deletePaymentMethod(method['id']),
                ),
                onTap: () {
                  widget.onSelect(
                    method['id'],
                    method['cardHolderName'],
                    method['cardNumber']
                        .substring(method['cardNumber'].length - 4),
                  );
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPaymentMethod,
        child: const Icon(Icons.add),
      ),
    );
  }
}
