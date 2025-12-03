import 'dart:io';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/geolocationHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  String _streetAddress = '';
  String _suburb = '';
  String _city = '';
  String _province = '';
  String _postalCode = '';
  bool _isSubmitting = false;
  bool _isLocationFetched = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final location = await GeolocationHelper.getCurrentLocation();
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _streetAddress = place.street ?? 'Unknown Street';
          _suburb = place.subLocality ?? 'Unknown Suburb';
          _city = place.locality ?? 'Unknown City';
          _province = place.administrativeArea ?? 'Unknown Province';
          _postalCode = place.postalCode ?? 'Unknown Postal Code';
          _isLocationFetched = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location fetched successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    }
  }

  Future<void> _uploadImageAndReport() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (_image == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please capture an image and ensure you are logged in.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_image!);

      final imageUrl = await storageRef.getDownloadURL();

      // Save the report to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'userID': userId,
        'date': DateTime.now(),
        'description': _descriptionController.text.trim(),
        'location': {
          'street': _streetAddress,
          'suburb': _suburb,
          'city': _city,
          'province': _province,
          'postalCode': _postalCode,
        },
        'imageUrl': imageUrl,
        'status': 'open',
        'response': '', // Initial empty response
      });

      // Clear the fields after submission
      setState(() {
        _image = null;
        _descriptionController.clear();
        _streetAddress = '';
        _suburb = '';
        _city = '';
        _province = '';
        _postalCode = '';
        _isLocationFetched = false;
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit report')),
      );
    }
  }

  Widget _buildReportedList() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Center(child: Text('User not logged in.'));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .where('userID', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reports found.'));
        }

        final reports = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            final reportData = report.data() as Map<String, dynamic>;
            final isClosed = reportData['status'] == 'closed';
            final response = reportData['response'] ?? 'No response yet';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: _buildImagePreview(reportData['imageUrl']),
                title: Text(reportData['description'] ?? 'No description'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${isClosed ? 'Closed' : 'Open'}'),
                    Text('Response: $response'),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor),
                onTap: () => _viewReportDetails(reportData),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_not_supported, color: Colors.grey);
      },
    );
  }

  void _viewReportDetails(Map<String, dynamic> reportData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailsPage(reportData: reportData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Illegal Dump Site'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? Image.file(
                      _image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text(
                          'Tap to take picture',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Use Current Location'),
              style: elevatedButtonStyle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _uploadImageAndReport,
              style: elevatedButtonStyle,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Report'),
            ),
            const SizedBox(height: 16),
            const Text('Your Reports:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildReportedList(),
          ],
        ),
      ),
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportDetailsPage({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final isClosed = reportData['status'] == 'closed';
    final response = reportData['response'] ?? 'No response yet';

    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reportData['imageUrl'] != null)
                Image.network(
                  reportData['imageUrl'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported,
                        color: Colors.grey);
                  },
                ),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                reportData['description'] ?? 'No description provided',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Location:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Street: ${reportData['location']['street'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Suburb: ${reportData['location']['suburb'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'City: ${reportData['location']['city'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Province: ${reportData['location']['province'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Postal Code: ${reportData['location']['postalCode'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Status:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                isClosed ? 'Closed' : 'Open',
                style: TextStyle(
                  color: isClosed ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Response:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                response,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (isClosed)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: elevatedButtonStyle,
                  child: const Text('Back to Reports'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
