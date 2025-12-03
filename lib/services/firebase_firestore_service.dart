// import 'package:binpack_residents/models/driver.dart';
// import 'package:binpack_residents/models/user.dart';
// import 'package:binpack_residents/models/waste_request.dart';
// import 'package:binpack_residents/models/waste_type.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class FirebaseFirestoreService {
//   final CollectionReference _usersCollectionRef = FirebaseFirestore.instance.collection('users');
//   final CollectionReference _wasteTypesCollectionRef = FirebaseFirestore.instance.collection('waste_types');
//   final CollectionReference _wasteRequestsCollectionRef = FirebaseFirestore.instance.collection('waste_requests');
//   final CollectionReference _driversCollectionRef = FirebaseFirestore.instance.collection('drivers');

//   Future<void> createUser(User user) async {
//     return await _usersCollectionRef.doc(user.uid).set(user.toJson());
//   }

//   Future<void> createWasteRequest(WasteRequest wasteRequest) async {
//     return await _wasteRequestsCollectionRef.doc(wasteRequest.id).set(wasteRequest.toJson());
//   }

//   Stream<List<WasteRequest>> getWasteRequestsByUserId(String uid) {
//     return _wasteRequestsCollectionRef.where('userId', isEqualTo: uid).snapshots().map((snapshot) => snapshot.docs.map((doc) => WasteRequest.fromJson(doc.data() as Map<String, dynamic>)).toList());
//   }

//   Future<void> createDriver(Driver driver) async {
//     return await _driversCollectionRef.doc(driver.uid).set(driver.toJson());
//   }

//   Stream<List<WasteRequest>> getWasteRequestsByDriverLocation(String location) {
//     return _wasteRequestsCollectionRef.where('wasteDepot', isEqualTo: location).where('status', isEqualTo: 'pending').snapshots().map((snapshot) => snapshot.docs.map((doc) => WasteRequest.fromJson(doc.data() as Map<String, dynamic>)).toList());
//   }

//   Future<void> updateWasteRequestStatus(String wasteRequestId, String status) async {
//     return await _wasteRequestsCollectionRef.doc(wasteRequestId).update({
//       'status': status,
//     });
//   }

//   Stream<List<WasteType>> getWasteTypes() {
//     return _wasteTypesCollectionRef.snapshots().map((snapshot) => snapshot.docs.map((doc) => WasteType.fromJson(doc.data() as Map<String, dynamic>)).toList());
//   }

//   Future<void> addWasteType(WasteType wasteType) async {
//     return await _wasteTypesCollectionRef.doc(wasteType.id).set(wasteType.toJson());
//   }
// }
