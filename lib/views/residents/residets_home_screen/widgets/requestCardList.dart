import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/request_cards/RequestCardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestCardList extends StatelessWidget {
  final String userId;
  final List<WasteCollectionRequest> filteredRequests;
  // final FocusNode focusNode;

  const RequestCardList({
    super.key,
    required this.userId,
    required this.filteredRequests,
    // required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wasteCollectionRequests')
          .where('userID', isEqualTo: userId)
          .where('status', isEqualTo: 'inProgress')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return isMobile
              ? _buildMobileEmptyState(context, theme)
              : _buildTabletEmptyState(theme);
        }

        final allRequests = snapshot.data!.docs
            .map((doc) => WasteCollectionRequest.fromFirestore(doc))
            .toList();
        final filtered =
            filteredRequests.isEmpty ? allRequests : filteredRequests;

        return SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return RequestCard(request: filtered[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Navigation-amico.png', height: 150),
          const SizedBox(height: 16),
          Text(
            'No requests found.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new request',
            style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabletEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Navigation-amico.png', height: 150),
          const SizedBox(height: 16),
          Text(
            'No requests found. To create a new request, select a request type on the right.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Icon(Icons.arrow_forward, size: 32, color: Colors.grey),
        ],
      ),
    );
  }
}
