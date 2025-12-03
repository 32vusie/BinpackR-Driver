// import 'package:binpack_residents/models/waste_request.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:binpack_residents/models/users/resident.dart';

// import '../../../../../../../../utils/enums.dart';

// class BankFunctions {

// static Future<void> fetchWasteCollectionRequests(Residents resident) async {
//   try {
//     // Fetch the waste collection requests using the 'where' query
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('wasteCollectionRequests')
//         .where('userID', isEqualTo: resident.userID)
//         .get();

//     // Process the retrieved data
//     List<WasteCollectionRequest> collectionRequests = [];
//     for (var doc in querySnapshot.docs) {
//       // Map the fields from the document to the class properties
//       WasteCollectionRequest request = WasteCollectionRequest(
//         wasteRequestID: doc['wasteRequestID'],
//         userID: doc['userID'],
//         wasteTypeID: List<String>.from(doc['wasteTypeID']),
//         date: (doc['date'] as Timestamp).toDate(),
//         location: doc['location'],
//         imageUrl: doc['imageUrl'],
//         driverID: doc['driverID'],
//         status: doc['status'],
//         weight: doc['weight'],
//         qrInfo: doc['qrInfo'],
//         rating: doc['rating'],
//         notificationSent: doc[false],
//         incentive: doc[0],
//       );
//       collectionRequests.add(request);
//     }

//     // Process the collection requests
//     for (WasteCollectionRequest request in collectionRequests) {
//       // Example: Print the ID of each request
//       print('Request ID: ${request.wasteRequestID}');
//       print('User ID: ${request.userID}');
//       // Print other properties as needed

//       // You can perform other processing here based on your requirements
//     }

//     // ... (Additional processing of data remains the same)
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }



//   static Future<void> fetchAccountInfo(dynamic user) async {
//     try {
//       // Determine the collection based on the role of the user (resident/driver)
//       String collectionName = (user is Residents) ? 'users' : 'drivers';
      
//       final userDoc = await FirebaseFirestore.instance
//           .collection(collectionName)
//           .doc(user.userID) // userID for Residents and driverID for Driver
//           .get();

//       if (userDoc.exists) {
//         final userData = userDoc.data()!;
        
//         // Constructing AccountInfo object from fetched data
//         AccountInfo accountInfo = AccountInfo(
//           accountNumber: userData['accountInfo']['accountNumber'] ?? '',
//           balance: userData['accountInfo']['balance']?.toDouble() ?? 0.0,
//           cardInfo: CardInfo(
//             cardNumber: userData['accountInfo']['cardInfo']['cardNumber'] ?? '',
//             cardExpiry: userData['accountInfo']['cardInfo']['cardExpiry'] ?? '',
//             cardCSV: userData['accountInfo']['cardInfo']['cardCSV'] ?? 0,
//             pin: userData['accountInfo']['cardInfo']['pin'] ?? '',
//           ),
//         );

//         // Update the user's account information
//         user.accountInfo = accountInfo;
//       }
//     } catch (e) {
//       print('Error fetching account data: $e');
//     }
//   }

//   static double calculateIncentiveAmount(
//       List<WasteType> wasteTypes, double weight) {
//     // Define your logic for calculating incentive amount based on the provided enum
//     double totalIncentive = 0.0;

//     for (WasteType wasteType in wasteTypes) {
//       switch (wasteType) {
//         case WasteType.municipalSolidWaste:
//           totalIncentive += weight * 1.0;
//           break;
//         case WasteType.recyclableMaterials:
//           totalIncentive += weight * 2.0;
//           break;
//         case WasteType.organicWaste:
//           totalIncentive += weight * 0.5;
//           break;
//         case WasteType.hazardousWaste:
//           totalIncentive += weight * 3.0;
//           break;
//         case WasteType.electronicWaste:
//           totalIncentive += weight * 2.5;
//           break;
//         case WasteType.batteries:
//           totalIncentive += weight * 1.5;
//           break;
//         case WasteType.lightBulbs:
//           totalIncentive += weight * 1.2;
//           break;
//         case WasteType.constructionAndDemolitionWaste:
//           totalIncentive += weight * 1.8;
//           break;
//         case WasteType.furnitureAndAppliances:
//           totalIncentive += weight * 2.0;
//           break;
//         case WasteType.textiles:
//           totalIncentive += weight * 1.0;
//           break;
//         case WasteType.metalWaste:
//           totalIncentive += weight * 1.5;
//           break;
//         case WasteType.plasticBags:
//           totalIncentive += weight * 0.8;
//           break;
//         case WasteType.glassWaste:
//           totalIncentive += weight * 1.2;
//           break;
//         case WasteType.paperWaste:
//           totalIncentive += weight * 1.0;
//           break;
//         case WasteType.automotiveWaste:
//           totalIncentive += weight * 1.5;
//           break;
//         case WasteType.medicalWaste:
//           totalIncentive += weight * 3.5;
//           break;
//         case WasteType.gardenWaste:
//           totalIncentive += weight * 0.7;
//           break;
//         default:
//           // Handle unknown waste types if needed
//           break;
//       }
//     }

//     return totalIncentive;
//   }
// }
