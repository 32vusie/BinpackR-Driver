import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String transactionId;
  final String userId;
  final String description;
  final double amount;
  final DateTime date;

  Transactions({
    required this.transactionId,
    required this.userId,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      transactionId: json['transactionId'] ?? '',
      userId: json['userId'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'userId': userId,
        'description': description,
        'amount': amount,
        'date': Timestamp.fromDate(date),
      };
}
