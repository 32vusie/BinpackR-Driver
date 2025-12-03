// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class WasteClassificationScreen extends StatefulWidget {
//   @override
//   _WasteClassificationScreenState createState() => _WasteClassificationScreenState();
// }

// class _WasteClassificationScreenState extends State<WasteClassificationScreen> {
//   File? _image;
//   String _classificationResult = "Upload an image to classify waste.";

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _classifyWaste();
//       });
//     }
//   }

//   Future<void> _classifyWaste() async {
//   if (_image == null) return;

//   final inputImage = InputImage.fromFilePath(_image!.path);
//   final imageLabeler = GoogleMlKit.vision.imageLabeler();

//   try {
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
//     String result = "";

//     for (ImageLabel label in labels) {
//       result += '${label.label}: ${label.confidence.toStringAsFixed(2)}\n'; // Changed 'text' to 'label'
//     }

//     setState(() {
//       _classificationResult = result.isNotEmpty ? result : "No waste identified.";
//     });
//   } catch (e) {
//     setState(() {
//       _classificationResult = "Error classifying waste: $e";
//     });
//   } finally {
//     await imageLabeler.close(); // Close the labeler to release resources
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Waste Classification")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _image == null
//               ? Text('No image selected.')
//               : Image.file(_image!, height: 200, width: 200),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _pickImage,
//             child: Text("Pick Image"),
//           ),
//           SizedBox(height: 20),
//           Text(_classificationResult),
//         ],
//       ),
//     );
//   }
// }
