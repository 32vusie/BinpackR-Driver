import 'package:cloud_firestore/cloud_firestore.dart';

class WasteCollectionRequest {
  final String wasteRequestID;
  final String userID;
  List<String>
      wasteTypeID; // Removed 'late' keyword to allow reassignment without error
  final DateTime date;
  final GeoPoint location;
  final String imageUrl;
  String driverID; // Removed 'late' keyword to allow reassignment without error
  String status; // Removed 'late' keyword to allow reassignment without error
  double weight; // Removed 'late' keyword to allow reassignment without error
  final String qrInfo;
  final bool notificationSent;
  final double incentive;
  double rating;
  final String? paymentMethodId; // New field for payment method ID
  bool? isEventCollection;
  final DateTime updatedDateTime;

  WasteCollectionRequest({
    required this.wasteRequestID,
    required this.userID,
    required this.wasteTypeID,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.driverID,
    required this.status,
    required this.weight,
    required this.qrInfo,
    required this.notificationSent,
    required this.incentive,
    required this.rating,
    this.paymentMethodId,
    this.isEventCollection,
    required this.updatedDateTime,
  });

  factory WasteCollectionRequest.fromJson(Map<String, dynamic> json) {
    return WasteCollectionRequest(
      wasteRequestID: json['wasteRequestID'],
      userID: json['userID'],
      wasteTypeID: List<String>.from(json['wasteTypeID'] ?? []),
      date: (json['date'] as Timestamp).toDate(),
      location: json['location'] as GeoPoint,
      imageUrl: json['imageUrl'],
      driverID: json['driverID'],
      status: json['status'],
      weight: json['weight'] != null ? json['weight'].toDouble() : 0.0,
      qrInfo: json['qrInfo'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      notificationSent: json['notificationSent'] ?? false,
      incentive: json['incentive']?.toDouble() ?? 0.0,
      paymentMethodId: json['paymentMethodId'], // Deserialize payment method ID
      isEventCollection: json['isEventCollection'],
      updatedDateTime: (json['updatedDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory WasteCollectionRequest.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return WasteCollectionRequest(
    wasteRequestID: doc.id,
    userID: data['userID'] ?? '',
    wasteTypeID: List<String>.from(data['wasteTypeID'] ?? []),
    date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(), // Default to now if null
    location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0), // Default GeoPoint
    imageUrl: data['imageUrl'] ?? '',
    driverID: data['driverID'] ?? '',
    status: data['status'] ?? '',
    weight: data['weight']?.toDouble() ?? 0.0,
    qrInfo: data['qrInfo'] ?? '',
    rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    notificationSent: data['notificationSent'] ?? false,
    incentive: data['incentive']?.toDouble() ?? 0.0,
    paymentMethodId: data['paymentMethodId'], // Deserialize from Firestore
    isEventCollection: data['isEventCollection'] ?? false,
    updatedDateTime: (data['updatedDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}


  set scheduledDateTime(DateTime? scheduledDateTime) {}

  Map<String, dynamic> toJson() => {
        'wasteRequestID': wasteRequestID,
        'userID': userID,
        'wasteTypeID': wasteTypeID,
        'date': date,
        'location': location,
        'imageUrl': imageUrl,
        'driverID': driverID,
        'status': status,
        'weight': weight,
        'qrInfo': qrInfo,
        'rating': rating,
        'notificationSent': notificationSent,
        'incentive': incentive,
        'paymentMethodId': paymentMethodId, // Serialize payment method ID
        'isEventCollection': isEventCollection,
        'updatedDateTime': updatedDateTime,
      };

  WasteCollectionRequest copyWith({
    String? wasteRequestID,
    String? userID,
    List<String>? wasteTypeID,
    DateTime? date,
    GeoPoint? location,
    String? imageUrl,
    String? driverID,
    String? status,
    double? weight,
    String? qrInfo,
    double? rating,
    bool? notificationSent,
    double? incentive,
    String? paymentMethodId, // Added to copyWith method
    bool? isEventCollection,
    DateTime? updatedDateTime,
  }) {
    return WasteCollectionRequest(
      wasteRequestID: wasteRequestID ?? this.wasteRequestID,
      userID: userID ?? this.userID,
      wasteTypeID: wasteTypeID ?? this.wasteTypeID,
      date: date ?? this.date,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      driverID: driverID ?? this.driverID,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      qrInfo: qrInfo ?? this.qrInfo,
      rating: rating ?? this.rating,
      notificationSent: notificationSent ?? this.notificationSent,
      incentive: incentive ?? this.incentive,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      isEventCollection: isEventCollection ?? this.isEventCollection,
      updatedDateTime: updatedDateTime ?? this.updatedDateTime,
    );
  }
}
