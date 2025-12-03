import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/wastetype.dart';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/utils/location_filtering_field.dart';
// import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/functions/request_details.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/widgets/RequestDetails.dart';
import 'package:binpack_residents/views/residents/resident_request_details_screen/widgets/waste_dropdown_widget.dart';
// import 'package:binpack_residents/views/residents/residets_request_screen/widgets/WasteDropdownWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RequestDetailsScreen extends StatefulWidget {
  final WasteCollectionRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  late Future<Residents?> residentFuture;
  List<WasteType> wasteTypes = [];

  @override
  void initState() {
    super.initState();
    residentFuture = RequestDetailsService.fetchResident(widget.request.userID);
    _fetchWasteTypes();
  }

  Future<void> _fetchWasteTypes() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('waste_types').get();
      setState(() {
        wasteTypes = querySnapshot.docs.map((doc) {
          return WasteType(
            id: doc.id,
            name: doc['name'],
            grouping: doc['grouping'],
            pricePerKilo: (doc['pricePerKilo'] as num).toDouble(),
            currency: doc['currency'],
            isRecyclable: doc['isRecyclable'],
          );
        }).toList();
      });
    } catch (error) {
      _showErrorSnackbar("Failed to fetch waste types: $error");
    }
  }

  Future<void> _editRequest() async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController wasteWeightController =
        TextEditingController(text: widget.request.weight.toString());
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    WasteType? selectedWasteType = wasteTypes.isNotEmpty
        ? wasteTypes.firstWhere(
            (e) => e.id == widget.request.wasteTypeID.firstOrNull,
            orElse: () => wasteTypes.first,
          )
        : null;

    GeoPoint? updatedLocation = widget.request.location;
    DateTime? scheduledDateTime = widget.request.date;

    Future<void> selectDateTime() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            scheduledDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            dateController.text =
                DateFormat('yyyy-MM-dd').format(scheduledDateTime!);
            timeController.text =
                DateFormat('HH:mm').format(scheduledDateTime!);
          });
        }
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Request'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    try {
                      WasteCollectionRequest updatedRequest =
                          widget.request.copyWith(
                        wasteTypeID: [selectedWasteType?.id ?? ''],
                        weight:
                            double.tryParse(wasteWeightController.text) ?? 0.0,
                        location: updatedLocation,
                        date: scheduledDateTime,
                        status:
                            scheduledDateTime == null ? 'pending' : 'scheduled',
                      );

                      await RequestDetailsService.updateDocument(
                        'wasteCollectionRequests',
                        updatedRequest.wasteRequestID,
                        updatedRequest.toJson(),
                      );

                      setState(() {
                        // Assign updatedRequest values to the UI state if needed
                      });

                      Navigator.of(context).pop();
                      _showSuccessSnackbar("Request updated successfully");
                    } catch (error) {
                      _showErrorSnackbar("Failed to update request: $error");
                    }
                  }
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WasteDropdownWidget(
                      wasteTypes: wasteTypes,
                      selectedWasteType: selectedWasteType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedWasteType = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: wasteWeightController,
                      decoration:
                          InputDecorations.paragraph(label: 'Weight (KG)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          value!.isEmpty || double.tryParse(value) == null
                              ? 'Enter a valid weight'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    LocationSearchField(
                      onLocationSelected: (
                        String streetAddress,
                        String suburb,
                        String city,
                        String province,
                        String postalCode,
                      ) {
                        setState(() {
                          updatedLocation = const GeoPoint(
                              0.0, 0.0); // Replace with actual coordinates
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecorations.dateField(
                                label: 'Select Date'),
                            readOnly: true,
                            onTap: selectDateTime,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: timeController,
                            decoration: InputDecorations.timeField(
                                label: 'Select Time'),
                            readOnly: true,
                            onTap: selectDateTime,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SpinKitCircle(color: primaryColor, size: 16),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SpinKitCircle(color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Edit') _editRequest();
            },
            itemBuilder: (context) => {'Edit'}
                .map((choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ))
                .toList(),
          ),
        ],
      ),
      body: FutureBuilder<Residents?>(
        future: residentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return RequestDetails(snapshot.data!, widget.request, (status) async {
            await RequestDetailsService.updateDocument(
              'wasteCollectionRequests',
              widget.request.wasteRequestID,
              widget.request.toJson(),
            );
          });
        },
      ),
    );
  }
}
