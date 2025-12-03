import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PersonalWasteCollectionHistory extends StatelessWidget {
  final String userId;

  const PersonalWasteCollectionHistory({required this.userId, super.key});

  Future<Map<String, double>> _fetchWasteContribution() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .where('userID', isEqualTo: userId)
          .get();

      double organicWaste = 0;
      double recyclableWaste = 0;
      double otherWaste = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final weight = data['weight'] as double? ?? 0;
        final wasteType = (data['wasteTypeID'] as List<dynamic>?)?.first ?? 'Other';

        if (wasteType == 'Organic Waste') {
          organicWaste += weight;
        } else if (wasteType == 'Recyclable Waste') {
          recyclableWaste += weight;
        } else {
          otherWaste += weight;
        }
      }

      return {
        'Organic Waste': organicWaste,
        'Recyclable Waste': recyclableWaste,
        'Other': otherWaste,
      };
    } catch (e) {
      // Return empty data in case of errors
      return {'Organic Waste': 0, 'Recyclable Waste': 0, 'Other': 0};
    }
  }

  Stream<QuerySnapshot> _fetchCollectionHistory() {
    return FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> _fetchUpcomingSchedule() {
    return FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: userId)
        .where('status', isEqualTo: 'scheduled')
        .orderBy('date', descending: false)
        .limit(1)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Waste Contributed', style: Theme.of(context).textTheme.titleLarge),
              FutureBuilder<Map<String, double>>(
                future: _fetchWasteContribution(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading data.');
                  }

                  final wasteData = snapshot.data!;
                  return SfCircularChart(
                    legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                    series: <PieSeries<_WasteData, String>>[
                      PieSeries<_WasteData, String>(
                        dataSource: [
                          _WasteData('Organic Waste', wasteData['Organic Waste']!),
                          _WasteData('Recyclable Waste', wasteData['Recyclable Waste']!),
                          _WasteData('Other', wasteData['Other']!),
                        ],
                        xValueMapper: (_WasteData data, _) => data.type,
                        yValueMapper: (_WasteData data, _) => data.weight,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Collection History', style: Theme.of(context).textTheme.titleLarge),
              StreamBuilder<QuerySnapshot>(
                stream: _fetchCollectionHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading history.');
                  }

                  final history = snapshot.data!.docs;
                  if (history.isEmpty) {
                    return const Text('No collection history available.');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final data = history[index].data() as Map<String, dynamic>;
                      final date = (data['date'] as Timestamp).toDate();
                      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                      final wasteType = (data['wasteTypeID'] as List<dynamic>).join(', ');
                      final status = data['status'] ?? 'Unknown';

                      return ListTile(
                        title: Text('Date: $formattedDate'),
                        subtitle: Text('Waste Type: $wasteType\nStatus: $status'),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Upcoming Collection Schedule', style: Theme.of(context).textTheme.titleLarge),
              StreamBuilder<QuerySnapshot>(
                stream: _fetchUpcomingSchedule(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading schedule.');
                  }

                  final upcomingCollection = snapshot.data!.docs;
                  if (upcomingCollection.isEmpty) {
                    return const Text('No upcoming collections scheduled.');
                  }

                  final data = upcomingCollection.first.data() as Map<String, dynamic>;
                  final date = (data['date'] as Timestamp).toDate();
                  final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

                  return ListTile(
                    title: Text('Next Collection: $formattedDate'),
                    trailing: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reminder set for the upcoming collection!')),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WasteData {
  final String type;
  final double weight;

  _WasteData(this.type, this.weight);
}
