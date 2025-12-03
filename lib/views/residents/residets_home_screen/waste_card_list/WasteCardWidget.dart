import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/address.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/requestDetails.dart';
import 'package:binpack_residents/views/residents/residets_history_screen/history_screen/HistoryScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteCardList extends StatelessWidget {
  final Residents resident;

  const WasteCardList({super.key, required this.resident});

  WasteRequestStatus getRequestStatusFromString(String status) {
    return WasteRequestStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => WasteRequestStatus.pending,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Pending Requests', 'pending'),
        _buildStatusList(context, resident.userID, 'pending', theme),
      ],
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String status) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 7, 116, 11),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(
                    resident: resident,
                    // status: status,
                  ),
                ),
              );
            },
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 7, 116, 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusList(
      BuildContext context, String userId, String status, ThemeData theme) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .where('userID', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('date', descending: true)
          .limit(4)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(context, theme);
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot request = snapshot.data!.docs[index];
            WasteCollectionRequest wasteRequest =
                WasteCollectionRequest.fromJson(
              request.data() as Map<String, dynamic>,
            );
            WasteRequestStatus requestStatus =
                getRequestStatusFromString(wasteRequest.status);

            String formattedDate =
                DateFormat("dd MMM yyyy | HH:mm").format(wasteRequest.date);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsScreen(
                        request: wasteRequest,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.recycling,
                      color: getStatusColor(requestStatus),
                      size: 28.0,
                    ),
                    title: Text(
                      formattedDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getStatusDescription(requestStatus),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(requestStatus),
                          ),
                        ),
                        FutureBuilder<String>(
                          future: getFullAddress(
                            wasteRequest.location.latitude,
                            wasteRequest.location.longitude,
                          ),
                          builder: (context, addressSnapshot) {
                            if (addressSnapshot.hasData) {
                              return Text(
                                addressSnapshot.data!,
                                style: theme.textTheme.bodySmall,
                              );
                            } else if (addressSnapshot.hasError) {
                              return const Text(
                                'Location: Error loading address',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                            return Text(
                              'Location: Loading...',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            );
                          },
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color.fromARGB(255, 8, 116, 13),
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('assets/images/Navigation-cuate.png', height: 200),
            const SizedBox(height: 16),
            Text(
              'No pending requests found.',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(WasteRequestStatus status) {
    switch (status) {
      case WasteRequestStatus.pending:
        return Colors.orange;
      case WasteRequestStatus.collected:
        return primaryColor;
      case WasteRequestStatus.canceled:
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  String getStatusDescription(WasteRequestStatus status) {
    switch (status) {
      case WasteRequestStatus.pending:
        return 'Pending Collection';
      case WasteRequestStatus.collected:
        return 'Collected';
      case WasteRequestStatus.canceled:
        return 'Canceled';
      default:
        return 'Unknown Status';
    }
  }
}
