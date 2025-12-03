import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:binpack_residents/models/users/driver.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/widgets/DriverProfilePageWidget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:binpack_residents/views/residents/resident_map_view/mapScreenWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:intl/intl.dart';

class RequestDetails extends StatefulWidget {
  final Residents residents;
  final WasteCollectionRequest request;
  final Function(WasteRequestStatus) updateStatus;

  const RequestDetails(this.residents, this.request, this.updateStatus,
      {super.key});

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  Future<String> getAddress() async {
    final placemarks = await placemarkFromCoordinates(
      widget.request.location.latitude,
      widget.request.location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.country}';
    }
    return 'Address not available';
  }

  void _cancelRequest() async {
    try {
      await FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .doc(widget.request.wasteRequestID)
          .update({
        'status': WasteRequestStatus.canceled.toString().split('.').last,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request has been canceled successfully'),
        ),
      );
      widget.updateStatus(WasteRequestStatus.canceled);
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel request: $error')),
      );
    }
  }

  void markAsCollected(BuildContext context, String requestId) async {
    await FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .doc(requestId)
        .update({
      'status': WasteRequestStatus.collected.toString().split('.').last,
      'qrInfo': 'manual',
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request marked as collected successfully'),
        ),
      );
      widget.updateStatus(WasteRequestStatus.collected);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark request as collected: $error'),
        ),
      );
    });
  }

  void _showQrCodeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('wasteCollectionRequests')
              .doc(widget.request.wasteRequestID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading request data.'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final requestData = snapshot.data?.data();
            final status = requestData?['status'] ?? 'unknown';

            return StatefulBuilder(
              builder: (context, setState) {
                bool isCollected = status ==
                    WasteRequestStatus.collected.toString().split('.').last;

                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    color: isCollected ? Colors.green[50] : Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrettyQr(
                          data: widget.request.wasteRequestID,
                          size: 200.0,
                          roundEdges: true,
                          errorCorrectLevel: QrErrorCorrectLevel.M,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Request ID: ${widget.request.wasteRequestID}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        if (isCollected)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: primaryColor, size: 32),
                              SizedBox(width: 8),
                              Text(
                                'Collected',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _navigateToDriverProfile() async {
    if (widget.request.driverID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Driver ID is missing!'),
        ),
      );
      return;
    }

    try {
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(widget.request.driverID)
          .get();

      if (driverDoc.exists) {
        Driver driver = Driver.fromSnapshot(driverDoc);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverProfilePage(
              driver: driver,
              request: widget.request,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver not found!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching driver data: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isPending = widget.request.status == 'pending';
        // final bool isCollected = widget.request.status ==
        //     WasteRequestStatus.collected.toString().split('.').last;

        return Scaffold(
          body: Stack(
            children: [
              // Map as background
              SizedBox.expand(
                child: MapWidget(
                  location: widget.request.location,
                  driverID: widget.request.driverID,
                ),
              ),
              // Draggable details panel
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.qr_code, size: 36),
                            onPressed: () => _showQrCodeModal(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Request Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildInformationRow(
                            'Request ID:', widget.request.wasteRequestID),
                        _buildInformationRow('Status:', widget.request.status),
                        _buildInformationRow(
                            'Requested On:', _formatDate(widget.request.date)),
                        _buildInformationRow('Waste Type:',
                            widget.request.wasteTypeID.join(', ')),
                        _buildInformationRow(
                            'Weight:', '${widget.request.weight} kg'),
                        const Divider(height: 30, thickness: 1),
                        const Text(
                          'Requester Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildInformationRow(
                            'Requested By:', widget.residents.name),
                        _buildInformationRow(
                            'Pickup Location:', snapshot.data ?? 'Loading...'),
                        const Divider(height: 30, thickness: 1),
                        const Text(
                          'Driver Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          title: const Text(
                            'Driver Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(widget.request.driverID.isNotEmpty
                              ? 'Tap to view driver profile'
                              : 'Driver not assigned'),
                          onTap: _navigateToDriverProfile,
                        ),
                        const Divider(height: 30, thickness: 1),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: isPending ? _cancelRequest : null,
                                style: elevatedButtonStyle,
                                child: const Text(
                                  'Cancel Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                  height: 16), // Spacer between buttons
                              ElevatedButton(
                                onPressed: isPending
                                    ? () => markAsCollected(
                                        context, widget.request.wasteRequestID)
                                    : null,
                                style: elevatedButtonStyle,
                                child: const Text('Mark as Collected'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInformationRow(String label, String value) {
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

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date.toLocal());
  }
}
