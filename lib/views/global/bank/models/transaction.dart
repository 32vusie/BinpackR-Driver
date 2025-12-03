class Transaction {
  final String id;
  final String accountNumber;
  final double amount;
  final String reference;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.accountNumber,
    required this.amount,
    required this.reference,
    required this.timestamp,
  });
}
