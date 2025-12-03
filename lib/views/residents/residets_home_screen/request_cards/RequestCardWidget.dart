import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/views/global/adoptAcommunity/widgets/profilecardWidget.dart';
import 'package:binpack_residents/views/global/chat/chatScreen.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/requestDetails.dart';
import 'package:binpack_residents/models/users/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final WasteCollectionRequest request;
  final Driver? driver;

  const RequestCard({super.key, required this.request, this.driver});

  /// Fetches the count of unread messages for the waste request.
  Stream<int> getUnreadMessagesCountStream(String wasteRequestId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(wasteRequestId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('sender', isEqualTo: request.driverID)
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  /// Fetches the driver's data from Firestore.
  Future<Driver?> _fetchDriverData() async {
    if (driver != null) {
      return driver;
    }
    final driverDoc = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(request.driverID)
        .get();
    return driverDoc.exists
        ? Driver.fromJson(driverDoc.data() as Map<String, dynamic>)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth =
            constraints.maxWidth < 600 ? constraints.maxWidth : 340;

        return SizedBox(
          height: 220,
          width: cardWidth,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 83, 139, 20),
                    Color.fromARGB(255, 8, 116, 13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildActionButtons(context, theme),
                  const SizedBox(height: 16),
                  _buildDriverInfo(context, theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds action buttons for "View Request" and additional actions like chat and call.
  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestDetailsScreen(request: request),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            side: const BorderSide(color: Colors.white, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Text(
            'View Request',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        _buildChatAndCallButtons(context, theme),
      ],
    );
  }

  /// Builds buttons for chat and call functionality.
  Widget _buildChatAndCallButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            if (driver?.cellNumber != null && driver!.cellNumber.isNotEmpty) {
              final telScheme = 'tel:${driver!.cellNumber}';
              try {
                if (await canLaunchUrl(Uri.parse(telScheme))) {
                  await launchUrl(Uri.parse(telScheme));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to make a call.')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error launching call: $e')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Driver phone number is not available.')),
              );
            }
          },
          icon: const Icon(Icons.call, color: Colors.white),
        ),
        StreamBuilder<int>(
          stream: getUnreadMessagesCountStream(request.wasteRequestID),
          builder: (context, snapshot) {
            int unreadMessagesCount = snapshot.data ?? 0;

            // Display the badge only when there are unread messages
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ChatWidget(wasteRequest: request),
                    );
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                ),
                if (unreadMessagesCount >
                    0) // Only show the badge when there are unread messages
                  Positioned(
                    top: 0,
                    right: 0,
                    child: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: 0, end: 3),
                      badgeContent: Text(
                        '$unreadMessagesCount',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.white),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Builds the driver's information section.
  Widget _buildDriverInfo(BuildContext context, ThemeData theme) {
    return FutureBuilder<Driver?>(
      future: _fetchDriverData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
            'Error fetching driver data: ${snapshot.error}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
          );
        } else {
          final driverData = snapshot.data;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildDriverDetails(driverData, theme)),
              const SizedBox(width: 8),
              _buildDriverAvatar(context, driverData),
            ],
          );
        }
      },
    );
  }

  /// Builds detailed information about the driver.
  Widget _buildDriverDetails(Driver? driverData, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          driverData?.name ?? 'Driver Name',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          'VN: ${driverData?.vehicleInfo.brand} ${driverData?.vehicleInfo.model}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        Text(
          'Reg No: ${driverData?.vehicleInfo.plateNumber ?? 'N/A'}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        Text(
          'Date: ${request.date != null ? DateFormat('dd/MM/yyyy').format(request.date) : 'N/A'}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  /// Builds the driver's avatar.
  Widget _buildDriverAvatar(BuildContext context, Driver? driverData) {
    final imageProvider = (driverData?.profilePictureUrl.isNotEmpty ?? false)
        ? NetworkImage(driverData!.profilePictureUrl)
        : const AssetImage('assets/residents_images/small-residents.png')
            as ImageProvider;

    return InkWell(
      onTap: () {
        if (driverData?.profilePictureUrl != null &&
            driverData!.profilePictureUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenImageScreen(imageUrl: driverData.profilePictureUrl),
            ),
          );
        }
      },
      child: CircleAvatar(
        radius: 40,
        backgroundImage: imageProvider,
      ),
    );
  }
}
