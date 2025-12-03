import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/address.dart';

class HistoryCardWidget extends StatelessWidget {
  final WasteCollectionRequest request;
  final VoidCallback onCardTap;

  const HistoryCardWidget({
    super.key,
    required this.request,
    required this.onCardTap,
  });

  // Define colors and icons for each status
  Map<String, dynamic> _getStatusStyles(WasteRequestStatus status) {
    switch (status) {
      case WasteRequestStatus.completed:
        return {
          "color": Colors.green[50],
          "icon": Icons.recycling, // Just the icon data
          "iconColor": primaryColor, // Separate color data for the icon
        };
      case WasteRequestStatus.pending:
        return {
          "color": Colors.orange[50],
          "icon": Icons.pending,
          "iconColor": Colors.orange[800],
        };
      case WasteRequestStatus.canceled:
      case WasteRequestStatus.rejected:
        return {
          "color": Colors.red[50],
          "icon": Icons.close,
          "iconColor": Colors.red[800],
        };
      case WasteRequestStatus.scheduled_paid:
      case WasteRequestStatus.scheduled:
        return {
          "color": Colors.blue[50],
          "icon": Icons.account_balance_wallet_sharp,
          "iconColor": Colors.blue[700],
        };
      case WasteRequestStatus.inProgress:
        return {
          "color": Colors.green[50],
          "icon": Icons.sync,
          "iconColor": primaryColor,
        };
      case WasteRequestStatus.inRouteToDepot:
        return {
          "color": Colors.amber[50],
          "icon": Icons.recycling,
          "iconColor": Colors.amber,
        };
      case WasteRequestStatus.hazardous:
        return {
          "color": Colors.deepOrange[50],
          "icon": Icons.warning_amber_rounded,
          "iconColor": Colors.deepOrange,
        };
      default:
        return {
          "color": Colors.green[100],
          "icon": Icons.recycling,
          "iconColor": primaryColor,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM yyyy').format(request.date);
    final String formattedTime = DateFormat('HH:mm').format(request.date);

    // Get dynamic styles based on status
    final statusStyles = _getStatusStyles(
        WasteRequestStatusExtension.fromString(request.status));

    return GestureDetector(
      onTap: onCardTap,
      child: Card(
        color: statusStyles["color"],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Icon
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(
                  statusStyles["icon"], // Use the icon data
                  color:
                      statusStyles["iconColor"], // Apply the color dynamically
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Waste Type and Address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Waste Type - smaller and truncated text
                    const Text(
                      'WasteTypeExtension.fromString(request.wasteTypeID).displayName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Smaller font size
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    // Address - smaller and truncated
                    FutureBuilder<String>(
                      future: getFullAddress(
                        request.location.latitude,
                        request.location.longitude,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading address...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Text(
                            'Address not available',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          );
                        }
                        return Text(
                          snapshot.data!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12, // Smaller font size for address
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Date and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedDate, // Date
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size for date
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime, // Time
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size for time
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
