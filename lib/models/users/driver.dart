import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
   String driverID;
   String name;
   String email;
   String profilePictureUrl;
   DateTime lastActive;
   DateTime registrationDate;
   GeoPoint location;
  late final bool available;
   String cellNumber;
   double rating;
   VehicleInfo vehicleInfo;
   AccountInfo accountInfo;
   int rewardPoints;
   String wardId;
   String deviceId; // New field for device ID

  Driver({
    required this.driverID,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.lastActive,
    required this.registrationDate,
    required this.location,
    required this.available,
    required this.cellNumber,
    required this.rating,
    required this.vehicleInfo,
    required this.accountInfo,
    required this.rewardPoints,
    required this.wardId,
    required this.deviceId, // Include deviceId in the constructor
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverID: json['driverID'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      lastActive: json['lastActive']?.toDate() ?? DateTime.now(),
      registrationDate: json['registrationDate']?.toDate() ?? DateTime.now(),
      location: json['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      available: json['available'] ?? false,
      cellNumber: json['cellNumber'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      vehicleInfo: VehicleInfo.fromJson(json['vehicleInfo'] ?? {}),
      accountInfo: AccountInfo.fromJson(json['accountInfo'] ?? {}),
      rewardPoints: json['rewardPoints'] ?? 0,
      wardId: json['wardId'] ?? '',
      deviceId: json['deviceId'] ?? '', // Parse deviceId from JSON
    );
  }

  Map<String, dynamic> toJson() => {
        'driverID': driverID,
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'lastActive': lastActive,
        'registrationDate': registrationDate,
        'location': location,
        'available': available,
        'cellNumber': cellNumber,
        'rating': rating,
        'vehicleInfo': vehicleInfo.toJson(),
        'accountInfo': accountInfo.toJson(),
        'rewardPoints': rewardPoints,
        'wardId': wardId,
        'deviceId': deviceId, // Include deviceId in toJson
      };

  factory Driver.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Driver(
      driverID: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      lastActive: data['lastActive']?.toDate() ?? DateTime.now(),
      registrationDate: data['registrationDate']?.toDate() ?? DateTime.now(),
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      available: data['available'] ?? false,
      cellNumber: data['cellNumber'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      vehicleInfo: VehicleInfo.fromJson(data['vehicleInfo'] ?? {}),
      accountInfo: AccountInfo.fromJson(data['accountInfo'] ?? {}),
      rewardPoints: data['rewardPoints'] ?? 0,
      wardId: data['wardId'] ?? '',
      deviceId: data['deviceId'] ?? '', // Parse deviceId from Firestore snapshot
    );
  }
}

class VehicleInfo {
   String brand;
   String model;
   int year;
   String plateNumber;
   String color;
   String vehicleType;
   int vehicleCapacity;
   String vehicleImage;
   Documentation documentation;

  VehicleInfo({
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.color,
    required this.vehicleType,
    required this.vehicleCapacity,
    required this.vehicleImage,
    required this.documentation,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      plateNumber: json['plateNumber'] ?? '',
      color: json['color'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleCapacity: json['vehicleCapacity'] ?? '',
      vehicleImage: json['vehicleImage'] ?? '',
      documentation: Documentation.fromJson(json['documentation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
        'year': year,
        'plateNumber': plateNumber,
        'color': color,
        'vehicleType': vehicleType,
        'vehicleCapacity': vehicleCapacity,
        'vehicleImage': vehicleImage,
        'documentation': documentation.toJson(),
      };
}

class Documentation {
   String registrationDocument;
   String driversLicense;
   String prdp;
   String roadworthyCertificate;
   String insuranceDocument;
   String operatingLicense;

  Documentation({
    required this.registrationDocument,
    required this.driversLicense,
    required this.prdp,
    required this.roadworthyCertificate,
    required this.insuranceDocument,
    required this.operatingLicense,
  });

  factory Documentation.fromJson(Map<String, dynamic> json) {
    return Documentation(
      registrationDocument: json['registrationDocument'] ?? '',
      driversLicense: json['driversLicense'] ?? '',
      prdp: json['prdp'] ?? '',
      roadworthyCertificate: json['roadworthyCertificate'] ?? '',
      insuranceDocument: json['insuranceDocument'] ?? '',
      operatingLicense: json['operatingLicense'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'registrationDocument': registrationDocument,
        'driversLicense': driversLicense,
        'prdp': prdp,
        'roadworthyCertificate': roadworthyCertificate,
        'insuranceDocument': insuranceDocument,
        'operatingLicense': operatingLicense,
      };
}

class AccountInfo {
   String accountNumber;
   double balance;
   CardInfo cardInfo;

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
   String cardNumber;
   String cardExpiry;
   int cardCSV;
   String pin;

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
