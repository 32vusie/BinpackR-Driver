// import 'package:binpack_residents/models/users/driver.dart';
// import 'package:binpack_residents/models/waste_request.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// import '../views/global/chat/chatScreen.dart';

// class MessagingService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;

//   // Define a constant for WasteCollectionRequest
//   static const wasteRequest = WasteCollectionRequest;

//   static void openChatWithDriver(Driver driver, BuildContext context, {required WasteCollectionRequest wasteRequest}) {
//       print('Open chat with driver called');

//     Future.microtask(() async {
//       try {
//         String chatSessionId = await createChatSessionWithDriver(driver);

//         // Navigate to the chat screen and pass the chat session ID and WasteCollectionRequest
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatScreen(chatSessionId: chatSessionId, wasteRequest: wasteRequest),
//           ),
//         );
//       } catch (e) {
//         print('Error opening chat: $e');
//         // Handle the error, display an error message, etc.
//       }
//     });
//   }

//   static Future<String> createChatSessionWithDriver(Driver driver) async {
//     // Simulate creating a chat session with the driver on your backend
//     // In a real scenario, you would send a request to your backend to create a chat session
//     // and return a unique chat session ID or token.
//     // Example:
//     // final response = await http.post('your_backend_url', body: {'driverId': driver.id});
//     // final chatSessionId = json.decode(response.body)['chatSessionId'];
//     // return chatSessionId;

//     // For the sake of this example, we'll return a simulated chat session ID.
//     return 'simulatedChatSessionId';
//   }
// }
