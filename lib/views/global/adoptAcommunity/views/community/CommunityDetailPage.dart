import 'package:binpack_residents/utils/theme.dart';
import 'widgets/CommunityImage.dart';
import 'widgets/CommunityInfo.dart';
import '../posts/CommunityPostsList.dart';
import 'widgets/communityActions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';
import '../../widgets/businesses/BusinessesListPage.dart';
import '../../widgets/parks/ParksListPage.dart';

class CommunityDetailPage extends StatefulWidget {
  final Community community;

  const CommunityDetailPage({super.key, required this.community});

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  bool isAdopted = false;
  bool showDonationForm = false;
  final TextEditingController donationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAdopted();
  }

  Future<void> _checkIfAdopted() async {
    try {
      const userId = 'currentUserId'; // Replace with the actual current user ID
      final adoptionDoc = await FirebaseFirestore.instance
          .collection('userAdoptions')
          .doc(userId)
          .collection('adoptedCommunities')
          .doc(widget.community.communityID)
          .get();

      setState(() {
        isAdopted = adoptionDoc.exists;
      });
    } catch (e) {
      print('Error checking adoption status: $e');
    }
  }

  Future<void> adoptCommunity() async {
    const userId = 'currentUserId'; // Replace with the actual current user ID

    if (isAdopted) {
      return;
    }

    final communityRef = FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.community.communityID);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(communityRef);
        final currentData = snapshot.data()!;
        final currentCount = currentData['adoptedCount'] as int;

        // Increment adopted count
        transaction.update(communityRef, {
          'adoptedCount': currentCount + 1,
        });

        // Add the community to the user's adopted communities
        final userAdoptionsRef = FirebaseFirestore.instance
            .collection('userAdoptions')
            .doc(userId)
            .collection('adoptedCommunities')
            .doc(widget.community.communityID);

        // Update user adoptions
        transaction.set(userAdoptionsRef, {
          'adoptedAt': Timestamp.now(),
        });
      });

      setState(() {
        isAdopted = true;
        widget.community.adoptedCount++;
      });

      // Show confirmation modal after adoption
      _showAdoptionConfirmation();
    } catch (e) {
      print('Error adopting community: $e');
    }
  }

  void _showAdoptionConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Community Adopted'),
          content: const Text(
              'You have successfully adopted this community! Would you like to make a donation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDonationForm();
              },
              child: const Text('Yes, Donate'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No, Thanks'),
            ),
          ],
        );
      },
    );
  }

  void _showDonationForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Donation Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: donationController,
                decoration: const InputDecoration(
                  labelText: 'Donation Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                items: ['Parks', 'Businesses', 'Community Support']
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {},
                decoration: const InputDecoration(
                  labelText: 'Select Donation Category',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle donation submission
                Navigator.pop(context);
              },
              child: const Text('Submit Donation'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(widget.community.communityID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final communityData = snapshot.data!.data() as Map<String, dynamic>;
            final adoptedCount = communityData['adoptedCount'] as int;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommunityImage(imageUrl: widget.community.imageUrl),
                  const SizedBox(height: 20),
                  CommunityInfo(
                    name: widget.community.name,
                    description: widget.community.description,
                    adoptedCount: adoptedCount,
                  ),
                  const SizedBox(height: 20),
                  CommunityActions(
                    community: widget.community,
                    onNavigateToParks: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ParksListPage(parks: widget.community.parks),
                        ),
                      );
                    },
                    onNavigateToBusinesses: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessesListPage(
                              businesses: widget.community.businesses),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Community Posts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CommunityPostsList(activities: widget.community.activities),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: isAdopted
          ? null
          : FloatingActionButton(
              onPressed: adoptCommunity,
              backgroundColor: primaryColor,
              tooltip: 'Adopt Community',
              child: const Icon(Icons.favorite_border, color: Colors.white),
            ),
    );
  }
}
