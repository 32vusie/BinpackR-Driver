import 'dart:io';
import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'views/community_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart'; // Import the SpeedDial package

class ManageCommunitiesScreen extends StatefulWidget {
  const ManageCommunitiesScreen({super.key});

  @override
  _ManageCommunitiesScreenState createState() =>
      _ManageCommunitiesScreenState();
}

class _ManageCommunitiesScreenState extends State<ManageCommunitiesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Community> communities = [];
  String? _selectedCommunityId;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('communities').get();
      setState(() {
        communities = snapshot.docs
            .map(
                (doc) => Community.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
      print('Communities loaded: ${communities.length}');
    } catch (e) {
      print('Error loading communities: $e');
      setState(() {
        communities = [];
      });
    }
  }

  // Function to show community details and list posts, parks, businesses
  void _showCommunityDetails(Community community) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailsScreen(community: community),
      ),
    );
  }

  // Add a community with name and description
  void _showAddCommunityDialog() {
    final communityNameController = TextEditingController();
    final communityDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Community'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: communityNameController,
                decoration: const InputDecoration(labelText: 'Community Name'),
              ),
              TextField(
                controller: communityDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final newCommunity = Community(
                  communityID: _firestore.collection('communities').doc().id,
                  name: communityNameController.text,
                  description: communityDescriptionController.text,
                  adoptedCount: 0,
                  parks: [],
                  businesses: [],
                  activities: [],
                );

                // Add community
                await _firestore
                    .collection('communities')
                    .doc(newCommunity.communityID)
                    .set(newCommunity.toJson());

                Navigator.pop(context);
                _loadCommunities(); // Refresh the community list
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Add a park linked to a community
  void _showAddParkDialog(
      BuildContext context, Map<dynamic, dynamic> parkData) {
    final parkNameController = TextEditingController();
    final parkDescriptionController = TextEditingController();
    final locationController = TextEditingController();
    String? imageUrl; // Store the image URL or path
    String? selectedCommunityId;
    List<Community> filteredCommunities = communities;

    final picker = ImagePicker();

    Future<void> pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageUrl = pickedFile.path;
        });
      }
    }

    void filterCommunities(String query) {
      setState(() {
        filteredCommunities = communities
            .where((community) =>
                community.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Park'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: parkNameController,
                  decoration: const InputDecoration(labelText: 'Park Name'),
                ),
                TextField(
                  controller: parkDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                imageUrl == null
                    ? TextButton(
                        onPressed: pickImage,
                        child: const Text('Select Image'),
                      )
                    : Image.file(File(imageUrl!)),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Search Community'),
                  onChanged: filterCommunities,
                ),
                DropdownButton<String>(
                  hint: const Text('Select Community'),
                  value: selectedCommunityId,
                  items: filteredCommunities.map((community) {
                    return DropdownMenuItem<String>(
                      value: community.communityID,
                      child: Text(community.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunityId = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (selectedCommunityId == null ||
                    parkNameController.text.isEmpty ||
                    locationController.text.isEmpty) {
                  // Handle validation error
                  return;
                }

                final newPark = Park(
                  parkID: _firestore.collection('parks').doc().id,
                  name: parkNameController.text,
                  description: parkDescriptionController.text,
                  location: locationController.text,
                  imageUrl: imageUrl ?? '',
                  likes: 0,
                );

                // Add park to the selected community
                await _firestore
                    .collection('communities')
                    .doc(selectedCommunityId)
                    .update({
                  'parks': FieldValue.arrayUnion([newPark.toJson()]),
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add a business linked to a community
  void _showAddBusinessDialog() {
    final businessNameController = TextEditingController();
    final businessDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Business'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
              ),
              TextField(
                controller: businessDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                hint: const Text('Select Community'),
                value: _selectedCommunityId,
                items: communities.map((community) {
                  return DropdownMenuItem<String>(
                    value: community.communityID,
                    child: Text(community.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCommunityId = value;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_selectedCommunityId == null) return;
                final newBusiness = Business(
                  businessId: _firestore.collection('businesses').doc().id,
                  name: businessNameController.text,
                  description: businessDescriptionController.text,
                );

                // Add business to community
                await _firestore
                    .collection('communities')
                    .doc(_selectedCommunityId)
                    .update({
                  'businesses': FieldValue.arrayUnion([newBusiness.toJson()]),
                });

                Navigator.pop(context);
                _loadCommunities(); // Refresh the community list
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add a post linked to a community and optionally tag a business or park
  void _showAddPostDialog() {
    final postTitleController = TextEditingController();
    final postContentController = TextEditingController();
    final imageUrlController = TextEditingController(); // Add this
    String? selectedCommunityId;
    String? selectedParkId;
    String? selectedBusinessId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: postTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: postContentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              TextField(
                controller: imageUrlController, // Add this text field
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              DropdownButton<String>(
                hint: const Text('Select Community'),
                value: selectedCommunityId,
                items: communities.map((community) {
                  return DropdownMenuItem<String>(
                    value: community.communityID,
                    child: Text(community.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCommunityId = value;
                    selectedParkId = null; // Reset park and business selection
                    selectedBusinessId = null;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (selectedCommunityId != null) ...[
                DropdownButton<String>(
                  hint: const Text('Tag a Park'),
                  value: selectedParkId,
                  items: communities
                      .firstWhere((c) => c.communityID == selectedCommunityId)
                      .parks
                      .map((park) => DropdownMenuItem<String>(
                            value: park.parkID,
                            child: Text(park.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedParkId = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  hint: const Text('Tag a Business'),
                  value: selectedBusinessId,
                  items: communities
                      .firstWhere((c) => c.communityID == selectedCommunityId)
                      .businesses
                      .map((business) => DropdownMenuItem<String>(
                            value: business.businessId,
                            child: Text(business.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBusinessId = value;
                    });
                  },
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (selectedCommunityId == null) return;

                final newPost = Post(
                  postId: _firestore.collection('posts').doc().id,
                  title: postTitleController.text,
                  content: postContentController.text,
                  imageUrl: imageUrlController.text, // Use image URL
                  communityId: selectedCommunityId!,
                  parkId: selectedParkId,
                  businessId: selectedBusinessId,
                  timestamp: Timestamp.now(),
                  likes: 0,
                );

                // Add post to community
                await _firestore
                    .collection('communities')
                    .doc(selectedCommunityId)
                    .update({
                  'activities': FieldValue.arrayUnion([newPost.toJson()]),
                });

                Navigator.pop(context);
                _loadCommunities(); // Refresh the community list
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Floating action button with SpeedDial for adding different entities
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Communities'),
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          return ListTile(
            title: Text(community.name),
            subtitle: Text(community.description),
            onTap: () => _showCommunityDetails(community),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Add Community',
            onTap: _showAddCommunityDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.location_city),
            label: 'Add Park',
            onTap: () {
              final parkData = {/* Some park-related data or initialization */};
              _showAddParkDialog(
                  context, parkData); // Handle data appropriately
            },
          ),

          // Pass context here
          // ),
          SpeedDialChild(
            child: const Icon(Icons.store),
            label: 'Add Business',
            onTap: _showAddBusinessDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.post_add),
            label: 'Add Post',
            onTap: _showAddPostDialog,
          ),
        ],
        child: const Icon(Icons.add),
      ),
    );
  }
}
