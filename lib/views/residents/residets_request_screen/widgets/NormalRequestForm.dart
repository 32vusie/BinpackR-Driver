import 'package:binpack_residents/models/incentives.dart';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/utils/location_filtering_field.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/WasteDropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NormalRequestForm extends StatefulWidget {
  final Function(FormData) onSubmit;

  const NormalRequestForm({required this.onSubmit, super.key});

  @override
  _NormalRequestFormState createState() => _NormalRequestFormState();
}

class _NormalRequestFormState extends State<NormalRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wasteWeightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  WasteType? _selectedWasteType;
  String _location = '';
  DateTime? _scheduledDateTime;

  Future<void> _selectDateTime() async {
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
          _scheduledDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text =
              DateFormat('yyyy-MM-dd').format(_scheduledDateTime!);
          _timeController.text =
              DateFormat('HH:mm').format(_scheduledDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMobile)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Normal Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: primaryColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('How Normal Request Works'),
                                content: const Text(
                                  'A "Normal Request" is a standard waste collection request. '
                                  'This service follows the regular schedule and does not have an additional fee. '
                                  'You can schedule a convenient date and time for your waste to be collected.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Got it!'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                WasteTypeDropdown(
                  selectedWasteType: _selectedWasteType,
                  onChanged: (WasteType? newValue) {
                    setState(() {
                      _selectedWasteType = newValue;
                    });
                  },
                  isPaidRequest: false, // Set to true for paid requests
                ),

                const SizedBox(height: 16),
                // TextFormField(
                //   controller: _wasteWeightController,
                //   decoration: InputDecorations.paragraph(label: 'Weight (KG)'),
                //   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                //   validator: (value) => value!.isEmpty ? 'Enter waste weight' : null,
                // ),
                // const SizedBox(height: 16),
                LocationSearchField(
                  onLocationSelected: (
                    String streetAddress,
                    String suburb,
                    String city,
                    String province,
                    String postalCode,
                  ) {
                    setState(() {
                      _location =
                          '$streetAddress, $suburb, $city, $province, $postalCode';
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration:
                            InputDecorations.dateField(label: 'Select Date'),
                        readOnly: true,
                        onTap: _selectDateTime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        decoration:
                            InputDecorations.timeField(label: 'Select Time'),
                        readOnly: true,
                        onTap: _selectDateTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: elevatedButtonStyle,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onSubmit(
                        FormData(
                          formKey: _formKey,
                          selectedWasteType: _selectedWasteType,
                          wasteWeight:
                              double.tryParse(_wasteWeightController.text) ?? 0,
                          qrInfo: 'noqrcode',
                          location: _location,
                          incentives: [],
                          paymentAmount: 0.0,
                          scheduledDateTime: _scheduledDateTime,
                          isEventCollection: false,
                        ),
                      );
                    }
                  },
                  child: const Text('Request Collection'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormData {
  final GlobalKey<FormState> formKey;
  final WasteType? selectedWasteType;
  final double wasteWeight;
  final String qrInfo;
  final String location;
  final List<Incentive> incentives;
  final double paymentAmount;
  final DateTime? scheduledDateTime;
  final String? paymentMethodId;
  final bool isEventCollection;

  FormData({
    required this.formKey,
    this.selectedWasteType,
    required this.wasteWeight,
    required this.qrInfo,
    required this.location,
    required this.incentives,
    required this.paymentAmount,
    this.scheduledDateTime,
    this.paymentMethodId,
    required this.isEventCollection,
  });
}
