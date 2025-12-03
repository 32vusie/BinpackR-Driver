import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/utils/enums.dart';
import 'package:binpack_residents/utils/location_filtering_field.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/WasteRequestScreen.dart';
import 'package:binpack_residents/views/global/payment_method/PaymentMethodScreen.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/WasteDropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaidRequestForm extends StatefulWidget {
  final Function(FormData) onSubmit;

  const PaidRequestForm({required this.onSubmit, super.key});

  @override
  _PaidRequestFormState createState() => _PaidRequestFormState();
}

class _PaidRequestFormState extends State<PaidRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wasteWeightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  WasteType? _selectedWasteType;
  String _location = '';
  DateTime? _scheduledDateTime;
  String? _selectedPaymentMethodId;
  bool _isEventCollection = false;

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

  void _openPaymentMethodScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          onSelect: (String paymentMethodId, String cardHolderName,
              String last4Digits) {
            setState(() {
              _selectedPaymentMethodId = '$cardHolderName - $last4Digits';
            });
          },
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Waste collection request submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How Paid Request Works'),
        content: const Text(
          'A "Paid Request" is a priority service where users can request immediate waste collection. '
          'This service may include additional charges based on factors such as location, waste type, '
          'and any special handling requirements. Scheduling a paid request ensures your waste is '
          'collected at the earliest convenience.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
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
                          'Paid Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: primaryColor),
                          onPressed: _showInfoDialog,
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
                  isPaidRequest: true, // Set to false for normal requests
                ),
                CustomWidgets.checkbox(
                  value: _isEventCollection,
                  label: 'Event Waste Collection?',
                  onChanged: (value) {
                    setState(() {
                      _isEventCollection = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 8),
                // TextFormField(
                //   controller: _wasteWeightController,
                //   decoration: InputDecorations.paragraph(label: 'Weight (KG)'),
                //   keyboardType:
                //       const TextInputType.numberWithOptions(decimal: true),
                //   validator: (value) =>
                //       value!.isEmpty ? 'Enter waste weight' : null,
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
                GestureDetector(
                  onTap: _openPaymentMethodScreen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payment, color: primaryColor),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            _selectedPaymentMethodId ?? 'Select Payment Method',
                            style: const TextStyle(color: primaryColor),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: primaryColor, size: 16),
                      ],
                    ),
                  ),
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
                          paymentMethodId: _selectedPaymentMethodId,
                          isEventCollection: _isEventCollection,
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
