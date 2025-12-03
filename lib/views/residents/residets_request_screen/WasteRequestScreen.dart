import 'package:binpack_residents/views/residents/residets_request_screen/widgets/NormalRequestForm.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/PaidRequestForm.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/waste_learning/widgets/bannerWidge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../models/incentives.dart';
import '../../../utils/enums.dart';
import 'functions/waste_request_functions.dart';

class WasteRequestCollection extends StatelessWidget {
  const WasteRequestCollection({super.key});

  void _showNormalRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: NormalRequestForm(
          onSubmit: (formData) {
            submitNormalRequest(
              context: context,
              formKey: formData.formKey,
              wasteTypes: [formData.selectedWasteType!],
              wasteWeight: formData.wasteWeight,
              qrInfo: 'noqrcode',
              location: formData.location,
              incentives: List<Incentive>.from(formData.incentives),
              scheduledDateTime: formData.scheduledDateTime,
            );
          },
        ),
      ),
    );
  }

  void _showPaidRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: PaidRequestForm(
          onSubmit: (formData) {
            submitPaidRequest(
              context: context,
              formKey: formData.formKey,
              wasteTypes: [formData.selectedWasteType!],
              wasteWeight: formData.wasteWeight,
              qrInfo: 'noqrcode',
              location: formData.location,
              incentives: List<Incentive>.from(formData.incentives),
              isEventCollection: formData.isEventCollection,
              paymentAmount: formData.paymentAmount,
              scheduledDateTime: formData.scheduledDateTime,
              paymentMethodId: formData.paymentMethodId,
            );
          },
        ),
      ),
    );
  }

  void _showLearningModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/Recycling-bro.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Learn About Waste Collection',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Participate in waste collection by learning more about the processes involved. '
                  'Waste collection is a critical part of keeping our environment clean and safe. '
                  'Learn how you can make a difference today.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Different Types of Waste Collection Requests:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '- Normal Request: A standard waste collection request with no scheduling.\n'
                  '- Scheduled Request: Schedule your waste collection at a specific time.\n'
                  '- Paid Request: A premium service with scheduling and additional payment.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Collection Request'),
      ),
      body: Center(
        child: BannerWidget(
          imageUrl: 'assets/images/Recycling-bro.png',
          heading: 'Learn About Waste Collection',
          paragraph:
              'Click below to learn more about how you can participate in waste collection.',
          onLearnMore: () => _showLearningModal(context),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 8, 116, 13),
        overlayColor: Colors.black.withOpacity(0.5),
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.handyman,
                color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Normal Request',
            onTap: () => _showNormalRequestForm(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.payment,
                color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Paid Request',
            onTap: () => _showPaidRequestForm(context),
          ),
        ],
      ),
    );
  }
}

class FormData {
  final GlobalKey<FormState> formKey;
  final WasteType? selectedWasteType; // Ensure this uses the correct WasteType
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
