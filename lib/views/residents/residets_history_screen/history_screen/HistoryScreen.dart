import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/requestDetails.dart';
import 'package:binpack_residents/views/residents/residets_history_screen/history_screen/widget/HistoryCardListWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  final Residents resident;

  const HistoryScreen({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: UserHistoryRequestList(resident: resident),
    );
  }
}

class UserHistoryRequestList extends StatefulWidget {
  final Residents resident;

  const UserHistoryRequestList({super.key, required this.resident});

  @override
  _UserHistoryRequestListState createState() => _UserHistoryRequestListState();
}

class _UserHistoryRequestListState extends State<UserHistoryRequestList> {
  String? selectedStatus;
  DateTimeRange? selectedDateRange;
  Map<DateTime, int> requestCounts = {};

  @override
  void initState() {
    super.initState();
    _loadRequestCounts();
  }

  Future<void> _loadRequestCounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: widget.resident.userID)
        .get();

    Map<DateTime, int> counts = {};
    for (var doc in snapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      DateTime onlyDate = DateTime(date.year, date.month, date.day);
      counts[onlyDate] = (counts[onlyDate] ?? 0) + 1;
    }

    setState(() {
      requestCounts = counts;
    });
  }

  Stream<QuerySnapshot> _getFilteredRequests() {
    Query query = FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: widget.resident.userID)
        .orderBy('date', descending: true);

    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      query = query.where('status', isEqualTo: selectedStatus);
    }

    if (selectedDateRange != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: selectedDateRange!.start,
        isLessThanOrEqualTo: selectedDateRange!.end,
      );
    }

    return query.snapshots();
  }

  bool get isFiltered => selectedStatus != null || selectedDateRange != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Filter by Status',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedStatus,
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('All Statuses')),
                    ...WasteRequestStatus.values
                        .map((status) => DropdownMenuItem<String>(
                              value: status.statusString,
                              child: Text(status.statusString),
                            )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.calendar_today,
                    semanticLabel: 'Pick a date range'),
                onPressed: () async {
                  DateTimeRange? pickedRange = await showDateRangePicker(
                    context: context,
                    initialDateRange: selectedDateRange,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedRange != null) {
                    setState(() {
                      selectedDateRange = pickedRange;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        if (isFiltered)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedStatus = null;
                    selectedDateRange = null;
                  });
                },
                child: const Text('Reset Filters'),
              ),
            ),
          ),
        StreamBuilder<QuerySnapshot>(
          stream: _getFilteredRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No requests history found. Try adjusting the filters.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              );
            }

            List<WasteCollectionRequest> requests = snapshot.data!.docs
                .map((doc) => WasteCollectionRequest.fromJson(
                    doc.data() as Map<String, dynamic>))
                .toList();

            return Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Requests: ${requests.length}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return HistoryCardWidget(
                          request: requests[index],
                          onCardTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestDetailsScreen(
                                  request: requests[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
