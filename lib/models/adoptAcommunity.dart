import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  final String communityID;
  final String name;
  final String description;
  late final int adoptedCount;
  final List<Park> parks;
  final List<Business> businesses;
  final List<CommunityActivity> activities;
  final String? imageUrl;

  Community({
    required this.communityID,
    required this.name,
    required this.description,
    required this.adoptedCount,
    required this.parks,
    required this.businesses,
    required this.activities,
    this.imageUrl,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    // Safely handle Timestamp fields
    DateTime? createdAt = json['createdAt'] != null
        ? (json['createdAt'] as Timestamp?)?.toDate()
        : null;

    return Community(
      communityID: json['communityID'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      adoptedCount: json['adoptedCount'] ?? 0,
      parks: (json['parks'] as List<dynamic>?)
              ?.map((park) => Park.fromJson(park as Map<String, dynamic>))
              .toList() ??
          [],
      businesses: (json['businesses'] as List<dynamic>?)
              ?.map((business) =>
                  Business.fromJson(business as Map<String, dynamic>))
              .toList() ??
          [],
      activities: (json['activities'] as List<dynamic>?)
              ?.map((activity) =>
                  CommunityActivity.fromJson(activity as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'communityID': communityID,
        'name': name,
        'description': description,
        'adoptedCount': adoptedCount,
        'parks': parks.map((p) => p.toJson()).toList(),
        'businesses': businesses.map((b) => b.toJson()).toList(),
        'activities': activities.map((a) => a.toJson()).toList(),
        'imageUrl': imageUrl,
      };
}

class Park {
  final String parkID;
  final String name;
  final String description;
  final String location;
  final String imageUrl;
  final int likes;

  Park({
    required this.parkID,
    required this.name,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.likes,
  });

  factory Park.fromJson(Map<String, dynamic> json) {
    return Park(
      parkID: json['parkID'],
      name: json['name'],
      description: json['description'],
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parkID': parkID,
      'name': name,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'likes': likes,
    };
  }
}

class Business {
  final String businessId;
  final String name;
  final String description;
  // final String communityId;

  Business({
    required this.businessId,
    required this.name,
    required this.description,
    // required this.communityId,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessId: json['businessId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // communityId: json['communityId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'businessId': businessId,
        'name': name,
        'description': description,
        // 'communityId': communityId,
      };
}

class CommunityActivity {
  final String postID;
  final String userId;
  final String userName;
  final String activityType;
  final String content;
  final DateTime? date; // Changed to DateTime?
  final DateTime? createdAt; // Changed to DateTime?
  final String? imageUrl;
  final String? communityId;

  CommunityActivity({
    required this.postID,
    required this.userId,
    required this.userName,
    required this.activityType,
    required this.content,
    this.date,
    this.createdAt,
    this.imageUrl,
    this.communityId,
  });

  // Convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'userId': userId,
      'userName': userName,
      'activityType': activityType,
      'content': content,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      // 'imageUrl': imageUrl['imageUrl'], // Ensure this matches your Firestore field
      'communityId': communityId,
    };
  }

  // Create an instance from a JSON object
  factory CommunityActivity.fromJson(Map<String, dynamic> json) {
    return CommunityActivity(
      postID: json['postID'] ?? '', // Ensure postID is included
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      activityType: json['activityType'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] != null ? (json['date'] as Timestamp).toDate() : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      imageUrl: json['imageUrl'], // Ensure this matches your Firestore field
      communityId: json['communityId']  ?? 'No communityId',
    );
  }
}

// class CommunityActivity {
//   final String postId;
//   final String content;
//   final String title;
//   final String imageUrl;
//   final int likes;
//   final String communityId;

//   CommunityActivity({
//     required this.postId,
//     required this.content,
//     required this.title,
//     required this.imageUrl,
//     required this.likes,
//     required this.communityId,
//   });

//   // Factory constructor to create an instance from a JSON map
//   factory CommunityActivity.fromJson(Map<String, dynamic> json) {
//     return CommunityActivity(
//       postId: json['postId'] as String,
//       content: json['content'] as String,
//       title: json['title'] as String,
//       imageUrl: json['imageUrl'] as String,
//       likes: json['likes'] as int,
//       communityId: json['communityId'] as String,
//     );
//   }
// }

class Post {
  final String postId;
  final String title;
  final String content;
  final String? parkId; // Optional Park ID
  final String? businessId; // Optional Business ID
  final String communityId; // Required Community ID
  final String? imageUrl; // Optional image URL
  final Timestamp timestamp;
  final int likes;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    this.parkId,
    this.businessId,
    required this.communityId, // Community ID is required
    this.imageUrl, // Optional field
    required this.timestamp,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'parkId': parkId,
      'businessId': businessId,
      'communityId': communityId,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
    };
  }
}
