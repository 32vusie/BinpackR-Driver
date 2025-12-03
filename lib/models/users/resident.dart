import 'package:cloud_firestore/cloud_firestore.dart';

class Residents {
  final String userID;
  final String name;
  final String email;
  final String role;
  final String deviceId;
  final String profilePictureUrl;
  final DateTime lastActive;
  final DateTime registrationDate;
  final String cellNumber;
  final double rating;
  final int rewardPoints;
  final String wardId;
  final AccountInfo accountInfo;

  // Address fields
  final String streetAddress;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;

  // Wallet fields
  // final Wallet wallet;

  // Additional fields
  final bool isLoggedIn;
  final String fcmToken;
  final String residentialDocumentUrl;

  Residents({
    required this.userID,
    required this.name,
    required this.email,
    required this.role,
    required this.deviceId,
    required this.profilePictureUrl,
    required this.lastActive,
    required this.registrationDate,
    required this.cellNumber,
    required this.rating,
    required this.rewardPoints,
    required this.wardId,
    required this.accountInfo,
    required this.streetAddress,
    required this.suburb,
    required this.city,
    required this.province,
    required this.postalCode,
    // required this.wallet,
    required this.isLoggedIn,
    required this.fcmToken,
    required this.residentialDocumentUrl,
  });

  factory Residents.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Residents(
      userID: data['userID'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      deviceId: data['deviceId'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      lastActive: data['lastActive']?.toDate() ?? DateTime.now(),
      registrationDate: data['registrationDate']?.toDate() ?? DateTime.now(),
      cellNumber: data['cellNumber'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      rewardPoints: data['rewardPoints'] ?? 0,
      wardId: data['wardId'] ?? '',
      accountInfo: AccountInfo.fromJson(data['accountInfo'] ?? {}),
      streetAddress: data['streetAddress'] ?? '',
      suburb: data['suburb'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      postalCode: data['postalCode'] ?? '',
      // wallet: Wallet.fromJson(data['wallet'] ?? {}),
      isLoggedIn: data['isLoggedIn'] ?? false,
      fcmToken: data['fcmToken'] ?? '',
      residentialDocumentUrl: data['residentialDocumentUrl'] ?? '',
    );
  }

  factory Residents.fromJson(Map<String, dynamic> json) {
    return Residents(
      userID: json['userID'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      deviceId: json['deviceId'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      lastActive: json['lastActive']?.toDate() ?? DateTime.now(),
      registrationDate: json['registrationDate']?.toDate() ?? DateTime.now(),
      cellNumber: json['cellNumber'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      rewardPoints: json['rewardPoints'] ?? 0,
      wardId: json['wardId'] ?? '',
      accountInfo: AccountInfo.fromJson(json['accountInfo'] ?? {}),
      streetAddress: json['streetAddress'] ?? '',
      suburb: json['suburb'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postalCode'] ?? '',
      // wallet: Wallet.fromJson(json['wallet'] ?? {}),
      isLoggedIn: json['isLoggedIn'] ?? false,
      fcmToken: json['fcmToken'] ?? '',
      residentialDocumentUrl: json['residentialDocumentUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'name': name,
        'email': email,
        'role': role,
        'deviceId': deviceId,
        'profilePictureUrl': profilePictureUrl,
        'lastActive': lastActive,
        'registrationDate': registrationDate,
        'cellNumber': cellNumber,
        'rating': rating,
        'rewardPoints': rewardPoints,
        'wardId': wardId,
        'accountInfo': accountInfo.toJson(),
        'streetAddress': streetAddress,
        'suburb': suburb,
        'city': city,
        'province': province,
        'postalCode': postalCode,
        // 'wallet': wallet.toJson(),
        'isLoggedIn': isLoggedIn,
        'fcmToken': fcmToken,
        'residentialDocumentUrl': residentialDocumentUrl,
      };
}

class AccountInfo {
  final String accountNumber;
  final double balance;
  final CardInfo cardInfo;

  AccountInfo({
    required this.accountNumber,
    required this.balance,
    required this.cardInfo,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      accountNumber: json['accountNumber'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      cardInfo: CardInfo.fromJson(json['cardInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'accountNumber': accountNumber,
        'balance': balance,
        'cardInfo': cardInfo.toJson(),
      };
}

class CardInfo {
  final String cardNumber;
  final String cardExpiry;
  final int cardCSV;
  final String pin;

  CardInfo({
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardCSV,
    required this.pin,
  });

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      cardNumber: json['cardNumber'] ?? '',
      cardExpiry: json['cardExpiry'] ?? '',
      cardCSV: json['cardCSV'] ?? 0,
      pin: json['pin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'cardExpiry': cardExpiry,
        'cardCSV': cardCSV,
        'pin': pin,
      };
}
