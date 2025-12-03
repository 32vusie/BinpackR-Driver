import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'postDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostList extends StatelessWidget {
  final Future<List<CommunityActivity>> postsFuture;

  const PostList({super.key, required this.postsFuture});

  // Function to fetch the community name by ID
  Future<String> _fetchCommunityName(String communityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('communities')
          .doc(communityId)
          .get();

      if (doc.exists) {
        return doc['name'] ?? 'Community';
      } else {
        return 'Community';
      }
    } catch (e) {
      return 'Community';
    }
  }

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommunityActivity>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }

        final posts = snapshot.data!;
        int crossAxisCount;
        double screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth < 600) {
          crossAxisCount = 2;
        } else if (screenWidth < 1200) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 6;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return FutureBuilder<String>(
              future: _fetchCommunityName(
                  post.communityId!), // Fetch the community name
              builder: (context, communitySnapshot) {
                String communityName = 'Community';
                if (communitySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  communityName = 'Loading...';
                } else if (communitySnapshot.hasError) {
                  communityName = 'Error';
                } else if (communitySnapshot.hasData) {
                  communityName = communitySnapshot.data!;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Adjust image height based on screen width (e.g., smaller on mobile)
                      double imageHeight = constraints.maxWidth <= 600
                          ? 100
                          : 140; // Use smaller height for mobile

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    post.imageUrl ??
                                        'https://via.placeholder.com/400',
                                    height: imageHeight,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      communityName,
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
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.activityType ?? 'No title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    post.content ?? 'No content',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 14, color: primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        post.createdAt != null
                                            ? timeAgo(post.createdAt!)
                                            : 'No date available',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.comment,
                                          size: 14, color: primaryColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
