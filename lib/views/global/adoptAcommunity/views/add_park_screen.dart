// import 'dart:io';

// import 'package:binpack_residents/models/adoptAcommunity.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';

// class AddParkScreen extends StatefulWidget {
//   final Map<dynamic, dynamic> parkData;

//   AddParkScreen({required this.parkData});

//   @override
//   _AddParkScreenState createState() => _AddParkScreenState();
// }

// class _AddParkScreenState extends State<AddParkScreen> {
//   final parkNameController = TextEditingController();
//   final parkDescriptionController = TextEditingController();
//   final locationController = TextEditingController();
//   String? imageUrl;
//   String? selectedCommunityId;
//   List<Placemark> placeMarks = [];
//   final picker = ImagePicker();

//   Future<void> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         imageUrl = pickedFile.path;
//       });
//     }
//   }

//   void fetchPlaceMarks() async {
//     final position = await Geolocator.getCurrentPosition();
//     final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     setState(() {
//       placeMarks = placemarks;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Park'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () async {
//               if (selectedCommunityId == null ||
//                   parkNameController.text.isEmpty ||
//                   locationController.text.isEmpty) {
//                 // Handle validation error
//                 return;
//               }

//               final newPark = Park(
//                 parkID: FirebaseFirestore.instance.collection('parks').doc().id,
//                 name: parkNameController.text,
//                 description: parkDescriptionController.text,
//                 location: locationController.text,
//                 imageUrl: imageUrl ?? '',
//                 likes: 0,
//               );

//               // Add park to the selected community
//               await FirebaseFirestore.instance
//                   .collection('communities')
//                   .doc(selectedCommunityId)
//                   .update({
//                 'parks': FieldValue.arrayUnion([newPark.toJson()]),
//               });

//               Navigator.pop(context); // Close the screen
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (imageUrl != null)
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   child: Image.file(File(imageUrl!), fit: BoxFit.cover),
//                 )
//               else
//                 TextButton(
//                   onPressed: pickImage,
//                   child: const Text('Select Image'),
//                 ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: parkNameController,
//                 decoration: const InputDecoration(labelText: 'Park Name'),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: parkDescriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//               ),
//               const SizedBox(height: 10),
//               LocationField(
//                 controller: locationController,
//                 onChanged: (address) {
//                   // Handle address changes
//                 },
//                 onGetCurrentLocation: fetchPlaceMarks,
//                 placeMarks: placeMarks,
//               ),
//               const SizedBox(height: 10),
//               DropdownButton<String>(
//                 hint: const Text('Select Community'),
//                 value: selectedCommunityId,
//                 items: communities.map((community) {
//                   return DropdownMenuItem<String>(
//                     value: community.communityID,
//                     child: Text(community.name),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCommunityId = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
