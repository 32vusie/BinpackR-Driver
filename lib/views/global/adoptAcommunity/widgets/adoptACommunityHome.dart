import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:binpack_residents/utils/theme.dart';
import '../views/community/CommunityDetailPage.dart';
import 'communityCard/floatingSearchBar.dart';
import '../views/posts/widgets/postList.dart';
import 'functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityGridPage extends StatefulWidget {
  const CommunityGridPage({super.key});

  @override
  _CommunityGridPageState createState() => _CommunityGridPageState();
}

class _CommunityGridPageState extends State<CommunityGridPage> {
  late Future<List<Community>> _communities;
  String _searchTerm = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _communities = CommunityService().getCommunities();
  }

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.yMMMd().format(date);
  }

  List<Community> _filterAndSortCommunities(List<Community> communities) {
    // Filter communities based on search term
    List<Community> filteredCommunities = communities
        .where((community) =>
            community.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            community.description
                .toLowerCase()
                .contains(_searchTerm.toLowerCase()))
        .toList();

    // Sort based on the combined count of activities, parks, and businesses
    filteredCommunities.sort((a, b) {
      int aCount = a.activities.length + a.parks.length + a.businesses.length;
      int bCount = b.activities.length + b.parks.length + b.businesses.length;
      return bCount.compareTo(aCount);
    });

    return filteredCommunities;
  }

  Map<String, List<Community>> _groupCommunitiesByDescription(
      List<Community> communities) {
    Map<String, List<Community>> groupedCommunities = {};
    for (var community in communities) {
      String description = community.description;
      if (!groupedCommunities.containsKey(description)) {
        groupedCommunities[description] = [];
      }
      groupedCommunities[description]!.add(community);
    }
    return groupedCommunities;
  }

  Widget _buildCommunityCard(Community community) {
    // Get the timestamp and last post description if available
    DateTime? createdAt = community.activities.isNotEmpty
        ? community.activities.first.createdAt
        : null;
    String lastPostDescription = community.activities.isNotEmpty
        ? community.activities.first.content
        : 'No posts available';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Community image
              community.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        community.imageUrl!,
                        height: 50,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                    ),
              // Category badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    community.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Last Post Description
                Text(
                  lastPostDescription,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                // Conditional Row or Column for date and comments
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Check if screen width is less than 600 for mobile layout
                    if (constraints.maxWidth < 600) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                createdAt != null
                                    ? timeAgo(createdAt)
                                    : 'No date available',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.comment,
                                  size: 14, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                '${community.activities.length} Posts',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Tablet/Desktop layout: Row with Spacer
                      return Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            createdAt != null
                                ? timeAgo(createdAt)
                                : 'No date available',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.comment,
                                  size: 14, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                '${community.activities.length} Posts',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Community>>(
        future: _communities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading communities'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No communities found.'));
          } else {
            List<Community> communities =
                _filterAndSortCommunities(snapshot.data!);
            Map<String, List<Community>> groupedCommunities =
                _groupCommunitiesByDescription(communities);

            return ListView(
              children: [
                FloatingSearchBar(
                  searchTerm: _searchTerm,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ...groupedCommunities.entries.map((entry) {
                  String description = entry.key;
                  List<Community> communities = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount;

                            // Determine grid layout based on available width
                            if (constraints.maxWidth >= 1200) {
                              crossAxisCount = 4; // Desktop
                            } else if (constraints.maxWidth >= 800) {
                              crossAxisCount = 3; // Tablet
                            } else {
                              crossAxisCount = 1; // Mobile
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(10.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: communities.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommunityDetailPage(
                                                community: communities[index]),
                                      ),
                                    );
                                  },
                                  child:
                                      _buildCommunityCard(communities[index]),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
      ),
      body: _currentIndex == 0
          ? _buildCommunityGrid()
          : PostList(postsFuture: CommunityService().getPosts()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Posts',
          ),
        ],
      ),
    );
  }
}
