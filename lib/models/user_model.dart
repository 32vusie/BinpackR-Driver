class UserModel {
  final String userID;
  final String name;
  final String email;
  final String role; // ["resident", "driver", "business", "government_official"]
  final String imageUrl;
  final DateTime lastActive;
  final DateTime registrationDate;
  final String cellNumber;
  final double rating;
  final AccountInfo accountInfo;
  final String ward;
  final List<String> wasteRequests;
  final int rewardPoints;
  final String? pinCode;
  final String? accountType;
  final List<String>? announcements;
  final List<String>? chatHistory;
  final VehicleInfo? vehicleInfo;
  final List<DateTime>? schedules;
  final String? businessName;
  final String? businessType;
  final String? businessAddress;
  final List<String>? businessContacts;
  final String? designation;
  final String? department;
  final List<String>? announcementsPosted;
  final List<String>? reports;
  final List<String>? comments;
  final List<String>? anonymousReports;
  final String? wardInformation;
  final String? linkedUID;

  UserModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.role,
    required this.imageUrl,
    required this.lastActive,
    required this.registrationDate,
    required this.cellNumber,
    required this.rating,
    required this.accountInfo,
    required this.ward,
    required this.wasteRequests,
    required this.rewardPoints,
    this.pinCode,
    this.accountType,
    this.announcements,
    this.chatHistory,
    this.vehicleInfo,
    this.schedules,
    this.businessName,
    this.businessType,
    this.businessAddress,
    this.businessContacts,
    this.designation,
    this.department,
    this.announcementsPosted,
    this.reports,
    this.comments,
    this.anonymousReports,
    this.wardInformation,
    this.linkedUID,
  });

  // Convert a User object into a JSON map.
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'name': name,
        'email': email,
        'role': role,
        'imageUrl': imageUrl,
        'lastActive': lastActive,
        'registrationDate': registrationDate,
        'cellNumber': cellNumber,
        'rating': rating,
        'accountInfo': accountInfo.toJson(),
        'ward': ward,
        'wasteRequests': wasteRequests,
        'rewardPoints': rewardPoints,
        'pinCode': pinCode,
        'accountType': accountType,
        'announcements': announcements,
        'chatHistory': chatHistory,
        'vehicleInfo': vehicleInfo?.toJson(),
        'schedules': schedules,
        'businessName': businessName,
        'businessType': businessType,
        'businessAddress': businessAddress,
        'businessContacts': businessContacts,
        'designation': designation,
        'department': department,
        'announcementsPosted': announcementsPosted,
        'reports': reports,
        'comments': comments,
        'anonymousReports': anonymousReports,
        'wardInformation': wardInformation,
        'linkedUID': linkedUID,
  };

  // Create a User object from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['userID'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        imageUrl: json['imageUrl'],
        lastActive: DateTime.parse(json['lastActive']),
        registrationDate: DateTime.parse(json['registrationDate']),
        cellNumber: json['cellNumber'],
        rating: json['rating'],
        accountInfo: AccountInfo.fromJson(json['accountInfo']),
        ward: json['ward'],
        wasteRequests: List<String>.from(json['wasteRequests']),
        rewardPoints: json['rewardPoints'],
        pinCode: json['pinCode'],
        accountType: json['accountType'],
        announcements: List<String>.from(json['announcements']),
        chatHistory: List<String>.from(json['chatHistory']),
        vehicleInfo: json['vehicleInfo'] != null
            ? VehicleInfo.fromJson(json['vehicleInfo'])
            : null,
        schedules: (json['schedules'] as List).map((i) => DateTime.parse(i)).toList(),
        businessName: json['businessName'],
        businessType: json['businessType'],
        businessAddress: json['businessAddress'],
        businessContacts: List<String>.from(json['businessContacts']),
        designation: json['designation'],
        department: json['department'],
        announcementsPosted: List<String>.from(json['announcementsPosted']),
        reports: List<String>.from(json['reports']),
        comments: List<String>.from(json['comments']),
        anonymousReports: List<String>.from(json['anonymousReports']),
        wardInformation: json['wardInformation'],
        linkedUID: json['linkedUID'],
  );
}

class AccountInfo {
  final String accountNumber;
  final double accountBalance;
  final String accountCardNumber;
  final int accountCardCsv;
  final String accountCardExpDate;
  final int accountPin;

  AccountInfo({
    required this.accountNumber,
    required this.accountBalance,
    required this.accountCardNumber,
    required this.accountCardCsv,
    required this.accountCardExpDate,
    required this.accountPin,
  });

  Map<String, dynamic> toJson() => {
        'accountNumber': accountNumber,
        'accountBalance': accountBalance,
        'accountCardNumber': accountCardNumber,
        'accountCardCsv': accountCardCsv,
        'accountCardExpDate': accountCardExpDate,
        'accountPin': accountPin,
  };

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
        accountNumber: json['accountNumber'],
        accountBalance: json['accountBalance'],
        accountCardNumber: json['accountCardNumber'],
        accountCardCsv: json['accountCardCsv'],
        accountCardExpDate: json['accountCardExpDate'],
        accountPin: json['accountPin'],
  );
}

class VehicleInfo {
  final String vehicleType;
  final String vehiclePlateNumber;

  VehicleInfo({
    required this.vehicleType,
    required this.vehiclePlateNumber,
  });

  Map<String, dynamic> toJson() => {
        'vehicleType': vehicleType,
        'vehiclePlateNumber': vehiclePlateNumber,
  };

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
        vehicleType: json['vehicleType'],
        vehiclePlateNumber: json['vehiclePlateNumber'],
  );
}
