import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/CommunityEngagement.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/EducationProgress.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/EnvironmentalImpactCharts.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/RewardsProgress.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/SupportRequests.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/widgets/WasteCollectionHistory.dart';
import 'package:flutter/material.dart';
import 'package:binpack_residents/utils/responsive_layout.dart';

class ResidentDashboardScreen extends StatefulWidget {
  const ResidentDashboardScreen({super.key, required this.userId});

  final String userId;

  @override
  _ResidentDashboardScreenState createState() =>
      _ResidentDashboardScreenState();
}

class _ResidentDashboardScreenState extends State<ResidentDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  void _updateSearchTerm(String search) {
    setState(() {
      _searchTerm = search.toLowerCase();
    });
  }

  bool _matchesSearch(String title) {
    return title.toLowerCase().contains(_searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Dashboard'),
      ),
      body: ResponsiveLayout(
        mobile: _DashboardMobile(
          userId: widget.userId,
          searchController: _searchController,
          onSearch: _updateSearchTerm,
          matchesSearch: _matchesSearch,
        ),
        tablet: _DashboardTablet(
          userId: widget.userId,
          searchController: _searchController,
          onSearch: _updateSearchTerm,
          matchesSearch: _matchesSearch,
        ),
        desktop: _DashboardDesktop(
          userId: widget.userId,
          searchController: _searchController,
          onSearch: _updateSearchTerm,
          matchesSearch: _matchesSearch,
        ),
      ),
    );
  }
}

// Search bar widget
class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const SearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}

// Mobile Layout
class _DashboardMobile extends StatelessWidget {
  final String userId;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final bool Function(String) matchesSearch;

  const _DashboardMobile({
    required this.userId,
    required this.searchController,
    required this.onSearch,
    required this.matchesSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SearchBar(searchController: searchController, onSearch: onSearch),
          if (matchesSearch('Recycling & Environmental Impact'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EnvironmentalImpactCharts(userId: userId),
            ),
          if (matchesSearch('Rewards & Incentives'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RewardsProgress(userId: userId),
            ),
          if (matchesSearch('Education Progress and Learning'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EducationProgress(userId: userId),
            ),
          if (matchesSearch('Personal Waste Collection History'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: WasteCollectionHistory(userId: userId),
            ),
          if (matchesSearch('Community Engagement'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CommunityEngagement(communityId: userId),
            ),
          if (matchesSearch('Communication and Support'))
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SupportRequests(userId: userId),
            ),
        ],
      ),
    );
  }
}

// Tablet Layout
class _DashboardTablet extends StatelessWidget {
  final String userId;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final bool Function(String) matchesSearch;

  const _DashboardTablet({
    required this.userId,
    required this.searchController,
    required this.onSearch,
    required this.matchesSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SearchBar(
                    searchController: searchController, onSearch: onSearch),
                if (matchesSearch('Personal Waste Collection History'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WasteCollectionHistory(userId: userId),
                  ),
                if (matchesSearch('Recycling & Environmental Impact'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EnvironmentalImpactCharts(userId: userId),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                if (matchesSearch('Rewards & Incentives'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RewardsProgress(userId: userId),
                  ),
                if (matchesSearch('Education Progress and Learning'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EducationProgress(userId: userId),
                  ),
                if (matchesSearch('Community Engagement'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CommunityEngagement(communityId: userId),
                  ),
                if (matchesSearch('Communication and Support'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SupportRequests(userId: userId),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Desktop Layout
class _DashboardDesktop extends StatelessWidget {
  final String userId;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final bool Function(String) matchesSearch;

  const _DashboardDesktop({
    required this.userId,
    required this.searchController,
    required this.onSearch,
    required this.matchesSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SearchBar(
                    searchController: searchController, onSearch: onSearch),
                if (matchesSearch('Personal Waste Collection History'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WasteCollectionHistory(userId: userId),
                  ),
                if (matchesSearch('Rewards & Incentives'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RewardsProgress(userId: userId),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                if (matchesSearch('Recycling & Environmental Impact'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EnvironmentalImpactCharts(userId: userId),
                  ),
                if (matchesSearch('Education Progress and Learning'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EducationProgress(userId: userId),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (matchesSearch('Community Engagement'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CommunityEngagement(communityId: userId),
                  ),
                if (matchesSearch('Communication and Support'))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SupportRequests(userId: userId),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
