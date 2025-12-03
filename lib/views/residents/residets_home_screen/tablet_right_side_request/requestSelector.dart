import 'package:binpack_residents/models/incentives.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/statistics_card/StatisticsCard.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/functions/waste_request_functions.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/NormalRequestForm.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/widgets/PaidRequestForm.dart';
import 'package:flutter/material.dart';

class RequestTypeSelector extends StatelessWidget {
  final String selectedRequestType;
  final ValueChanged<String> onRequestTypeSelected;
  final String userId;

  const RequestTypeSelector({
    super.key,
    required this.selectedRequestType,
    required this.onRequestTypeSelected,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> requestTypes = [
      {
        'type': 'Paid Request',
        'imagePath': 'assets/images/Navigation-amico.png',
        'description':
            'This is a paid waste collection request, prioritizing immediate service.',
      },
      {
        'type': 'Normal Request',
        'imagePath': 'assets/images/Pick-up-truck-amico.png',
        'description':
            'Standard waste collection request, queued in the regular schedule.',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Request Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: primaryColor),
                onPressed: () {
                  _showInfoDialog(context);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: requestTypes.length,
            itemBuilder: (context, index) {
              final request = requestTypes[index];
              return _buildRequestTypeCard(
                request['type']!,
                request['imagePath']!,
                request['description']!,
                context,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        StatisticsCard(userId: userId),
      ],
    );
  }

  Widget _buildRequestTypeCard(
      String type, String imagePath, String description, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onRequestTypeSelected(type);
        _navigateToRequestScreen(context, type);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: selectedRequestType == type ? primaryColor : Colors.grey,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedRequestType == type
                            ? primaryColor
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRequestScreen(BuildContext context, String requestType) {
    if (requestType == 'Paid Request') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaidRequestFormScreen(),
        ),
      );
    } else if (requestType == 'Normal Request') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NormalRequestFormScreen(),
        ),
      );
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Types Info'),
          content: const Text(
            'Different types of waste collection requests:\n\n'
            '- Paid Request: Immediate service with a premium fee.\n'
            '- Normal Request: Standard waste collection as per the regular schedule.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class PaidRequestFormScreen extends StatelessWidget {
  const PaidRequestFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paid Request'),
      ),
      body: PaidRequestForm(
        onSubmit: (formData) {
          submitPaidRequest(
            context: context,
            formKey: formData.formKey,
            wasteTypes: [formData.selectedWasteType!],
            wasteWeight: formData.wasteWeight,
            qrInfo: formData.qrInfo,
            location: formData.location,
            incentives: List<Incentive>.from(formData.incentives),
            isEventCollection: formData.isEventCollection,
            paymentAmount: formData.paymentAmount,
            scheduledDateTime: formData.scheduledDateTime,
            paymentMethodId: formData.paymentMethodId,
          );
        },
      ),
    );
  }
}

class NormalRequestFormScreen extends StatelessWidget {
  const NormalRequestFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normal Request'),
      ),
      body: NormalRequestForm(
        onSubmit: (formData) {
          submitNormalRequest(
            context: context,
            formKey: formData.formKey,
            wasteTypes: [formData.selectedWasteType!],
            wasteWeight: formData.wasteWeight,
            qrInfo: formData.qrInfo,
            location: formData.location,
            incentives: List<Incentive>.from(formData.incentives),
            scheduledDateTime: formData.scheduledDateTime,
          );
        },
      ),
    );
  }
}
