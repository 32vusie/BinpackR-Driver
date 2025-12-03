import 'package:binpack_residents/services/NotificationService.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/side_drawer/SideDrawerWidget.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/tablet_right_side_request/requestSelector.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/widgets/AppBarWidget.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/bottom_navigation/BottomNavigationWidget.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/community/CommunitiesWidget.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/statistics_card/StatisticsCard.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/waste_card_list/WasteCardWidget.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/widgets/requestCardList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:flutter/rendering.dart';

class ResidentsHome extends StatefulWidget {
  final Residents resident;
  final String userId;

  const ResidentsHome(
      {super.key, required this.resident, required this.userId});

  @override
  _ResidentsHomeState createState() => _ResidentsHomeState();
}

class _ResidentsHomeState extends State<ResidentsHome> {
  final NotificationService _notificationService = NotificationService();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isBottomNavVisible = true;
  String selectedRequestType = 'Paid Request';
  List<WasteCollectionRequest> filteredRequests = [];
  List<WasteCollectionRequest> allRequests = [];

  @override
  void initState() {
    super.initState();
    _notificationService.setupFirebaseMessaging(context);
    listenToWasteRequestStatusChanges();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomNavVisible) {
        setState(() => _isBottomNavVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomNavVisible) {
        setState(() => _isBottomNavVisible = true);
      }
    }
  }

  void listenToWasteRequestStatusChanges() {
    FirebaseFirestore.instance
        .collection('wasteCollectionRequests')
        .where('userID', isEqualTo: widget.userId)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final wasteRequest = WasteCollectionRequest.fromJson(doc.data());
        if (wasteRequest.status == 'inProgress' &&
            !wasteRequest.notificationSent) {
          _notificationService.sendNotificationToUser(
            widget.userId,
            'A driver has accepted your waste request with ID: ${wasteRequest.wasteRequestID}',
          );
          doc.reference.update({'notificationSent': true});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        residents: widget.resident,
      ),
      drawer: SideDrawerWidget(resident: widget.resident),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 768) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SideDrawerWidget(resident: widget.resident)),
                    Expanded(flex: 5, child: _buildContent(theme)),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: RequestTypeSelector(
                          selectedRequestType: selectedRequestType,
                          onRequestTypeSelected: (String selectedType) {
                            setState(() {
                              selectedRequestType = selectedType;
                            });
                          },
                          userId: widget.userId,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return _buildContent(theme);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar:
          _isBottomNavVisible && MediaQuery.of(context).size.width < 768
              ? BottomNavigationWidget(resident: widget.resident)
              : null,
    );
  }

  Widget _buildContent(ThemeData theme) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          RequestCardList(
            userId: widget.userId,
            filteredRequests: filteredRequests,
            // focusNode: _searchFocusNode,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 350),
            child: const CommunitiesWidget(),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(),
            child: WasteCardList(resident: widget.resident),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            if (isMobile) StatisticsCard(userId: widget.userId),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
