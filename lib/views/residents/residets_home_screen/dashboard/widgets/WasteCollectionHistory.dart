import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WasteCollectionHistory extends StatefulWidget {
  final String userId;

  const WasteCollectionHistory({required this.userId, super.key});

  @override
  _WasteCollectionHistoryState createState() => _WasteCollectionHistoryState();
}

class _WasteCollectionHistoryState extends State<WasteCollectionHistory> {
  final int rowsPerPageMobile = 7;
  final int rowsPerPageDesktop = 15;
  int _rowsPerPage = 7;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    _rowsPerPage = isMobile ? rowsPerPageMobile : rowsPerPageDesktop;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .where('userID', isEqualTo: widget.userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        final docs = snapshot.data!.docs;
        final paginatedDocs = docs.skip(_currentPage * _rowsPerPage).take(_rowsPerPage).toList();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Waste Collection History', style: TextStyle(fontSize: 20)),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleExport(value, docs),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'csv', child: Text('Export as CSV')),
                    const PopupMenuItem(value: 'excel', child: Text('Export as Excel')),
                    const PopupMenuItem(value: 'pdf', child: Text('Export as PDF')),
                  ],
                  child: const Icon(Icons.download),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Request ID')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Waste Amount (kg)')),
                ],
                rows: paginatedDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  final requestId = data['wasteRequestID'] ?? 'Unknown Request';
                  final status = data['status'] ?? 'Not Available';
                  final date = data['date'] != null
                      ? DateFormat('dd/MM/yyyy').format((data['date'] as Timestamp).toDate())
                      : 'Unknown Date';
                  final wasteAmount = data['weight']?.toStringAsFixed(2) ?? '0.00';

                  return DataRow(cells: [
                    DataCell(Text(requestId)),
                    DataCell(Text(status)),
                    DataCell(Text(date)),
                    DataCell(Text('$wasteAmount kg')),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(docs.length),
          ],
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalDocs) {
    final totalPages = (totalDocs / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text('Page ${_currentPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Future<void> _handleExport(String format, List<QueryDocumentSnapshot> docs) async {
    if (format == 'csv') {
      await _exportAsCSV(docs);
    }
    // Additional handlers for Excel or PDF can be implemented here.
  }

  Future<void> _exportAsCSV(List<QueryDocumentSnapshot> docs) async {
    List<List<String>> rows = [
      ['Request ID', 'Status', 'Date', 'Waste Amount (kg)']
    ];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final requestId = data['wasteRequestID'] ?? 'Unknown Request';
      final status = data['status'] ?? 'Not Available';
      final date = data['date'] != null
          ? DateFormat('dd/MM/yyyy').format((data['date'] as Timestamp).toDate())
          : 'Unknown Date';
      final wasteAmount = data['weight']?.toStringAsFixed(2) ?? '0.00';

      rows.add([requestId, status, date, wasteAmount]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/waste_collection_history.csv';
    final file = File(path);
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV exported to: $path')),
    );
  }
}
