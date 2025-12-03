import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EnvironmentalImpactCharts extends StatelessWidget {
  final String userId;

  const EnvironmentalImpactCharts({required this.userId, super.key});

  Future<Map<String, double>> _fetchRecyclingData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .where('userID', isEqualTo: userId)
          .get();

      double recyclableWeight = 0;
      double nonRecyclableWeight = 0;
      List<DateTime> dates = [];
      List<double> wasteWeights = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final weight = (data['weight'] is int)
    ? (data['weight'] as int).toDouble() // Convert int to double
    : (data['weight'] as double? ?? 0); // Default to 0 if null

        final isRecyclable = (data['wasteTypeID'] as List<dynamic>?)?.contains('Recyclable Waste') ?? false;

        if (isRecyclable) {
          recyclableWeight += weight;
        } else {
          nonRecyclableWeight += weight;
        }

        // Capture the date and weight for the line chart
        DateTime date = (data['date'] as Timestamp).toDate();
        dates.add(date);
        wasteWeights.add(weight);
      }

      return {
        'Recyclable': recyclableWeight,
        'Non-Recyclable': nonRecyclableWeight,
      };
    } catch (e) {
      throw Exception('Failed to fetch recycling data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _fetchRecyclingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final recyclingData = snapshot.data!;
        final double totalWeight = recyclingData['Recyclable']! + recyclingData['Non-Recyclable']!;
        final double co2EmissionsAvoided = recyclingData['Recyclable']! * 0.45; // Example factor
        final double landfillDiversion = recyclingData['Recyclable']!; // All recyclable weight as diversion
        final double recyclablePercentage = (recyclingData['Recyclable']! / totalWeight) * 100;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Recycling Contribution',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                SfCircularChart(
                  title: const ChartTitle(text: 'Recyclable vs Non-Recyclable (by Weight)'),
                  legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                  series: <PieSeries<_RecyclingData, String>>[
                    PieSeries<_RecyclingData, String>(
                      dataSource: [
                        _RecyclingData('Recyclable', recyclingData['Recyclable']!),
                        _RecyclingData('Non-Recyclable', recyclingData['Non-Recyclable']!),
                      ],
                      xValueMapper: (_RecyclingData data, _) => data.category,
                      yValueMapper: (_RecyclingData data, _) => data.weight,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Environmental Impact',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ImpactMetricCard(
                          title: 'CO₂ Emissions Avoided',
                          value: '${co2EmissionsAvoided.toStringAsFixed(2)} kg',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ImpactMetricCard(
                          title: 'Landfill Diversion',
                          value: '${landfillDiversion.toStringAsFixed(2)} kg',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ImpactMetricCard(
                          title: 'Total Waste Collected',
                          value: '${totalWeight.toStringAsFixed(2)} kg',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Waste Collection Over Time',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SfCartesianChart(
  primaryXAxis: const DateTimeCategoryAxis(),
  primaryYAxis: const NumericAxis(),
  series: <CartesianSeries>[
    LineSeries<_WasteData, DateTime>(
      dataSource: [
        _WasteData(DateTime(2024, 11, 21), 44),
        _WasteData(DateTime(2024, 11, 22), 97),
        _WasteData(DateTime(2024, 11, 29), 543),
      ],
      xValueMapper: (_WasteData data, _) => data.date,
      yValueMapper: (_WasteData data, _) => data.weight,
      markerSettings: const MarkerSettings(isVisible: true),
    ),
  ],
),

                const SizedBox(height: 16),
                Text(
                  'Recycling Percentage',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SfCircularChart(
                  title: const ChartTitle(text: 'Recycling Rate'),
                  series: <CircularSeries>[
                    DoughnutSeries<_RecyclingData, String>(
                      dataSource: [
                        _RecyclingData('Recyclable', recyclablePercentage),
                        _RecyclingData('Non-Recyclable', 100 - recyclablePercentage),
                      ],
                      xValueMapper: (_RecyclingData data, _) => data.category,
                      yValueMapper: (_RecyclingData data, _) => data.weight,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecyclingData {
  _RecyclingData(this.category, this.weight);

  final String category;
  final double weight;
}

class _WasteData {
  _WasteData(this.date, this.weight);

  final DateTime date;
  final double weight;
}

class ImpactMetricCard extends StatelessWidget {
  final String title;
  final String value;

  const ImpactMetricCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
