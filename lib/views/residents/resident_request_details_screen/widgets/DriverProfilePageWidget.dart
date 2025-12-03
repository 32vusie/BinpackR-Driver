import 'package:binpack_residents/models/waste_request.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:binpack_residents/models/users/driver.dart';

class DriverProfilePage extends StatefulWidget {
  final Driver driver;
  final WasteCollectionRequest request;

  const DriverProfilePage({
    super.key,
    required this.driver,
    required this.request,
  });

  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  double _rating = 0;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _checkIfRated();
    _rating = widget.driver.rating; // Initialize with current driver rating
  }

  Future<void> _checkIfRated() async {
    const userId = 'currentUserId'; // Replace with actual user ID

    final ratingQuery = await FirebaseFirestore.instance
        .collection('ratings')
        .where('userId', isEqualTo: userId)
        .where('requestId', isEqualTo: widget.request.wasteRequestID)
        .limit(1)
        .get();

    if (ratingQuery.docs.isNotEmpty) {
      setState(() {
        _hasRated = true;
        _rating = ratingQuery.docs.first.data()['rating'] ?? 0.0;
      });
    }
  }

  Future<void> _submitRating() async {
    const userId = 'currentUserId'; // Replace with actual user ID

    if (_hasRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already rated this driver.'),
        ),
      );
      return;
    }

    final driverRef = FirebaseFirestore.instance
        .collection('drivers')
        .doc(widget.driver.driverID);

    try {
      final driverSnapshot = await driverRef.get();
      final currentRating = driverSnapshot.data()?['rating'] ?? 0.0;
      final ratingCount = driverSnapshot.data()?['ratingCount'] ?? 0;

      final newRating =
          ((currentRating * ratingCount) + _rating) / (ratingCount + 1);

      await driverRef.update({
        'rating': newRating,
        'ratingCount': ratingCount + 1,
      });

      await FirebaseFirestore.instance
          .collection('ratings')
          .doc('$userId-${widget.driver.driverID}')
          .set({
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
        'requestId': widget.request.wasteRequestID,
        'userId': userId,
      });

      await FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .doc(widget.request.wasteRequestID)
          .update({
        'rating': _rating,
      });

      setState(() {
        _hasRated = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting rating: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.driver.name,
          style: const TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.driver.profilePictureUrl),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Text(
                widget.driver.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 40, thickness: 1.5),
            const Text(
              'Vehicle Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(
              label: 'Vehicle Registration:',
              value: widget.driver.vehicleInfo.plateNumber,
            ),
            _buildInfoRow(
              label: 'Vehicle Type:',
              value: widget.driver.vehicleInfo.vehicleType,
            ),
            const Divider(height: 40, thickness: 1.5),
            const Text(
              'Driver Ratings and Collection Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(
              label: 'Current Rating:',
              value: widget.driver.rating.toString(),
            ),
            const SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('wasteCollectionRequests')
                  .where('driverID', isEqualTo: widget.driver.driverID)
                  .where('status', isEqualTo: 'collected')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                int collectedCount = snapshot.data?.docs.length ?? 0;

                return Text('Number of Collections: $collectedCount');
              },
            ),
            const Divider(height: 40, thickness: 1.5),
            const Text(
              'Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(
              label: 'Availability:',
              value: widget.driver.available ? "Available" : "Not Available",
            ),
            const Divider(height: 40, thickness: 1.5),
            Center(
              child: Column(
                children: [
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 8, 116, 13),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  if (!_hasRated)
                    ElevatedButton(
                      onPressed: _submitRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                      ),
                      child: const Text(
                        'Submit Rating',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
