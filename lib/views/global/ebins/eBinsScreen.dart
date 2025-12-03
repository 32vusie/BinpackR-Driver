import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/views/global/ebins/eBinsCalculator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bank/screens/transactions/transactions_screen.dart'; // Adjust the import according to your project structure

class eBinsScreen extends StatefulWidget {
  final Residents resident;

  const eBinsScreen({super.key, required this.resident});

  @override
  _eBinsScreenState createState() => _eBinsScreenState();
}

class _eBinsScreenState extends State<eBinsScreen> {
  int totalEBins = 0;
  int numberOfCollectedRequests = 0; // Track number of collected requests
  bool _isLoading = false;
  String _message = '';
  final List<Map<String, dynamic>> _wasteRequests = [];
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchEBins();
  }

  Future<void> _fetchEBins() async {
    final doc = await FirebaseFirestore.instance
        .collection('eBins')
        .doc(widget.resident.userID)
        .get();

    if (doc.exists) {
      final eBinsData = doc.data()!;
      setState(() {
        totalEBins = eBinsData['totalEBins'] ?? 0; // Ensure default value
      });
    }
  }

  Future<void> _checkAndUpdateEBins() async {
    setState(() {
      _isLoading = true;
      _message = '';
      _wasteRequests.clear(); // Clear old requests
      _progress = 0.0;
    });

    try {
      final newRequests = await _getCompletedRequests();
      numberOfCollectedRequests =
          newRequests.length; // Update collected requests count

      if (numberOfCollectedRequests > 0) {
        await _calculateAndUpdateEBins(numberOfCollectedRequests);
        setState(() {
          _message = 'eBins updated successfully!';
        });
      } else {
        setState(() {
          _message = 'No new eBins to process.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to update eBins: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _getCompletedRequests() async {
    print(
        "Fetching collected waste requests for user: ${widget.resident.userID}");
    final requestSnapshot = await FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: widget.resident.userID)
        .where('status', isEqualTo: 'collected')
        .get();

    print(
        "Number of collected requests: ${requestSnapshot.docs.length}"); // Log number of documents

    List<String> requestIDs = [];
    final totalRequests = requestSnapshot.docs.length;

    for (var i = 0; i < totalRequests; i++) {
      var doc = requestSnapshot.docs[i];

      // Fetch waste request details
      bool isProcessedForEBins = doc.data().containsKey('isProcessedForEBins')
          ? doc['isProcessedForEBins']
          : true;

      int weight = doc.data().containsKey('weight')
          ? (doc['weight'] is int
              ? doc['weight']
              : (doc['weight'] as double).toInt())
          : 0;

      int allocatedEBins = doc.data().containsKey('allocatedEBins')
          ? (doc['allocatedEBins'] is int
              ? doc['allocatedEBins']
              : (doc['allocatedEBins'] as double).toInt())
          : 0;

      // Check if not processed and store data
      if (!isProcessedForEBins) {
        int calculatedEBins =
            eBinsCalculator.calculateEBins(1, 0, 0, 0, true, weight: weight);

        // Check if allocatedEBins is incorrect, and update Firestore if needed
        if (allocatedEBins != calculatedEBins) {
          allocatedEBins = calculatedEBins;

          await FirebaseFirestore.instance
              .collection('wasteCollectionRequests')
              .doc(doc.id)
              .set({
            'isProcessedForEBins': true,
            'allocatedEBins': allocatedEBins,
          }, SetOptions(merge: true));

          // Log transaction details for traceability
          await _logTransactionDetails(doc.id, weight, allocatedEBins);
        }

        // Store request details for viewing
        _wasteRequests.add({
          'wasteRequestID': doc.id, // Use 'requestId' here
          'allocatedEBins': allocatedEBins,
          'wasteTypeID': doc['wasteTypeID'], // Add wasteTypeID
          'weight': weight, // Add weight
          'status': doc['status'], // Add status
        });

        requestIDs.add(doc.id);
      }

      // Update progress bar as requests are processed
      setState(() {
        _progress = (i + 1) / totalRequests;
      });
    }

    return requestIDs;
  }

  Future<void> _logTransactionDetails(
      String requestId, int weight, int allocatedEBins) async {
    await FirebaseFirestore.instance.collection('transactions').add({
      'requestId': requestId,
      'residentId': widget.resident.userID,
      'weight': weight,
      'allocatedEBins': allocatedEBins,
      'transactionDate': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _calculateAndUpdateEBins(int numberOfRequests) async {
    int newEBins =
        eBinsCalculator.calculateEBins(numberOfRequests, 0, 0, 0, true);
    await eBinsCalculator.updateUserEBins(widget.resident.userID, newEBins);
    await _fetchEBins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eBins'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total eBins: $totalEBins',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Number of collected requests: $numberOfCollectedRequests',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAndUpdateEBins,
              style: elevatedButtonStyle,
              child: const Text('Check for New eBins'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) ...[
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 20),
            ],
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(_message,
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
            ],
            const SizedBox(height: 20),
            _buildWasteRequestsList(), // Display the waste requests
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionsScreen(
                      userId: widget.resident.userID,
                    ),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: const Text('View Transaction Details'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showStepsModal,
        child: const Icon(Icons.info),
      ),
    );
  }

  Widget _buildWasteRequestsList() {
    if (_wasteRequests.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Collected Waste Requests:',
              style: TextStyle(fontSize: 20)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _wasteRequests.length,
            itemBuilder: (context, index) {
              final request = _wasteRequests[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                      'Request ID: ${request['wasteRequestID']}'), // Fixed the key here
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Allocated eBins: ${request['allocatedEBins']}'),
                      Text('Waste Type ID: ${request['wasteTypeID']}'),
                      Text('Weight: ${request['weight']} kg'),
                      Text('Status: ${request['status']}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text('No collected waste requests to display.',
          style: TextStyle(fontSize: 16)),
    );
  }

  void _showStepsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Steps for Calculating eBins'),
          content: const Text(
            '1. Ensure waste requests are collected.\n'
            '2. Check the collected requests.\n'
            '3. Process the requests to update eBins.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
