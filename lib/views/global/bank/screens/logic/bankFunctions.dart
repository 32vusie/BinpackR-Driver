import 'package:binpack_residents/models/TransactionsModel.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> recordTransaction(
      String userId, String description, double amount) async {
    Transactions transaction = Transactions(
      transactionId: _firestore.collection('transactions').doc().id,
      userId: userId,
      description: description,
      amount: amount,
      date: DateTime.now(),
    );

    await _firestore
        .collection('transactions')
        .doc(transaction.transactionId)
        .set(transaction.toJson());
  }

  Future<bool> sendMoney(Residents fromResident, Residents toResident,
      double amount, String userId) async {
    if (fromResident.accountInfo.balance < amount) {
      return false; // Insufficient funds
    }

    WriteBatch batch = _firestore.batch();

    // Deduct the amount from the sender's account
    DocumentReference fromResidentRef =
        _firestore.collection('users').doc(fromResident.userID);
    batch.update(fromResidentRef,
        {'accountInfo.balance': fromResident.accountInfo.balance - amount});

    // Add the amount to the receiver's account
    DocumentReference toResidentRef =
        _firestore.collection('users').doc(toResident.userID);
    batch.update(toResidentRef,
        {'accountInfo.balance': toResident.accountInfo.balance + amount});

    // Commit the transaction
    await batch.commit();

    // Record the transaction
    await recordTransaction(userId,
        "Sent money to ${toResident.accountInfo.accountNumber}", -amount);

    return true;
  }

  Future<bool> saveMoney(
      Residents resident, double amount, String userId) async {
    if (amount <= 0) {
      return false; // Invalid amount
    }

    // Add the amount to the resident's balance
    await _firestore
        .collection('users')
        .doc(resident.userID)
        .update({'accountInfo.balance': resident.accountInfo.balance + amount});

    // Record the transaction
    await recordTransaction(userId, "Saved money", amount);

    return true;
  }

  Future<bool> payMoney(Residents resident, double amount, String forService,
      String userId) async {
    if (resident.accountInfo.balance < amount) {
      return false; // Insufficient funds
    }

    // Deduct the amount from the resident's balance
    await _firestore
        .collection('users')
        .doc(resident.userID)
        .update({'accountInfo.balance': resident.accountInfo.balance - amount});

    // Record the transaction
    await recordTransaction(userId, "Paid for $forService", -amount);

    return true;
  }

  Future<bool> investMoney(Residents resident, double amount,
      String inInvestment, String userId) async {
    if (resident.accountInfo.balance < amount) {
      return false; // Insufficient funds
    }

    // Deduct the amount from the resident's balance for the investment
    await _firestore
        .collection('users')
        .doc(resident.userID)
        .update({'accountInfo.balance': resident.accountInfo.balance - amount});

    // Record the transaction
    await recordTransaction(userId, "Invested in $inInvestment", -amount);

    return true;
  }

  Future<bool> buy(
      Residents resident, double amount, String product, String userId) async {
    if (resident.accountInfo.balance < amount) {
      return false; // Insufficient funds
    }

    // Deduct the amount from the resident's balance for the purchase
    await _firestore
        .collection('users')
        .doc(resident.userID)
        .update({'accountInfo.balance': resident.accountInfo.balance - amount});

    // Record the transaction
    await recordTransaction(userId, "Bought $product", -amount);

    return true;
  }

  Future<Residents?> fetchAccount(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return Residents.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<Residents?> fetchUserByAccountNumber(String accountNumber) async {
    QuerySnapshot queryResult = await _firestore
        .collection('users')
        .where('accountInfo.accountNumber', isEqualTo: accountNumber)
        .get();

    if (queryResult.docs.isNotEmpty) {
      return Residents.fromJson(
          queryResult.docs.first.data() as Map<String, dynamic>);
    }

    return null;
  }
}
