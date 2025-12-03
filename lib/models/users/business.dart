import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String businessId;
  final String name;
  final String description; // Added field
  final String location; // Added field
  final String email;
  final String type;
  final String category;
  final String businessImage;
  final String contactNumber;
  final Address address;
  final double rating;
  final DateTime registrationDate;
  final DateTime lastActive;
  final AccountInfo accountInfo;
  final int rewardPoints;
  final String wardId;
  final List<WasteData> wasteData;

  Business({
    required this.businessId,
    required this.name,
    required this.description,
    required this.location,
    required this.email,
    required this.type,
    required this.category,
    required this.businessImage,
    required this.contactNumber,
    required this.address,
    required this.rating,
    required this.registrationDate,
    required this.lastActive,
    required this.accountInfo,
    required this.rewardPoints,
    required this.wardId,
    required this.wasteData,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessId: json['businessId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '', // Parse description
      location: json['location'] ?? '', // Parse location
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      businessImage: json['businessImage'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      rating: json['rating']?.toDouble() ?? 0.0,
      registrationDate: (json['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (json['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      accountInfo: AccountInfo.fromJson(json['accountInfo'] ?? {}),
      rewardPoints: json['rewardPoints']?.toInt() ?? 0,
      wardId: json['wardId'] ?? '',
      wasteData: (json['wasteData'] as List<dynamic>?)
              ?.map((data) => WasteData.fromJson(data))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'businessId': businessId,
        'name': name,
        'description': description, // Serialize description
        'location': location, // Serialize location
        'email': email,
        'type': type,
        'category': category,
        'businessImage': businessImage,
        'contactNumber': contactNumber,
        'address': address.toJson(),
        'rating': rating,
        'registrationDate': registrationDate,
        'lastActive': lastActive,
        'accountInfo': accountInfo.toJson(),
        'rewardPoints': rewardPoints,
        'wardId': wardId,
        'wasteData': wasteData.map((data) => data.toJson()).toList(),
      };
}

class Address {
  final String streetAddress;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;

  Address({
    required this.streetAddress,
    required this.suburb,
    required this.city,
    required this.province,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      streetAddress: json['streetAddress'] ?? '',
      suburb: json['suburb'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'streetAddress': streetAddress,
        'suburb': suburb,
        'city': city,
        'province': province,
        'postalCode': postalCode,
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
      balance: json['balance']?.toDouble() ?? 0.0,
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

class WasteData {
  final String wasteId;
  final String wasteType;
  final String quantity;
  final DateTime dateGenerated;

  WasteData({
    required this.wasteId,
    required this.wasteType,
    required this.quantity,
    required this.dateGenerated,
  });

  factory WasteData.fromJson(Map<String, dynamic> json) {
    return WasteData(
      wasteId: json['wasteId'] ?? '',
      wasteType: json['wasteType'] ?? '',
      quantity: json['quantity'] ?? '',
      dateGenerated: json['dateGenerated']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'wasteId': wasteId,
        'wasteType': wasteType,
        'quantity': quantity,
        'dateGenerated': dateGenerated,
      };
}
