import 'package:flutter/material.dart';
import 'package:binpack_residents/models/adoptAcommunity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/utils/globalPadding.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatefulWidget {
  final CommunityActivity post;

  const PostDetailPage({super.key, required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isLiked = false;
  List<CommunityActivity> otherPosts = [];
  List<Map<String, dynamic>> comments = [];
  late CommunityActivity selectedPost;
  final TextEditingController _commentController = TextEditingController();
  List<String> mentionSuggestions = [];
  String currentUserId = 'currentUserId'; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    selectedPost = widget.post;
    _checkIfLiked();
    _loadCommunityPosts();
    _loadComments();
  }

  Future<void> _checkIfLiked() async {
    final likedDoc = await FirebaseFirestore.instance
        .collection('communities')
        .doc(selectedPost.communityId)
        .collection('activities')
        .doc(selectedPost.postID)
        .collection('likes')
        .doc(currentUserId)
        .get();

    setState(() {
      isLiked = likedDoc.exists;
    });
  }

  Future<void> _toggleLike() async {
    if (isLiked) {
      await FirebaseFirestore.instance
          .collection('communities')
          .doc(selectedPost.communityId)
          .collection('activities')
          .doc(selectedPost.postID)
          .collection('likes')
          .doc(currentUserId)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('communities')
          .doc(selectedPost.communityId)
          .collection('activities')
          .doc(selectedPost.postID)
          .collection('likes')
          .doc(currentUserId)
          .set({'likedAt': Timestamp.now()});
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  Future<void> _loadCommunityPosts() async {
    final communityId = selectedPost.communityId;
    if (communityId != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('communities')
            .doc(communityId)
            .collection('activities')
            .get();

        final fetchedPosts = querySnapshot.docs.map((doc) {
          return CommunityActivity.fromJson(doc.data());
        }).toList();

        setState(() {
          otherPosts = fetchedPosts
              .where((post) => post.postID != selectedPost.postID)
              .toList();
        });
      } catch (e) {
        print("Error loading posts: $e");
      }
    }
  }

  Future<void> _loadComments() async {
    try {
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('communities')
          .doc(selectedPost.communityId)
          .collection('activities')
          .doc(selectedPost.postID)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        comments = commentsSnapshot.docs.map((doc) {
          return {
            'commentId': doc.id,
            ...doc.data(),
            'liked': false,
          };
        }).toList();
      });
    } catch (e) {
      print("Error loading comments: $e");
    }
  }

  Future<void> _addComment(String content) async {
    final commentId = FirebaseFirestore.instance
        .collection('communities')
        .doc(selectedPost.communityId)
        .collection('activities')
        .doc(selectedPost.postID)
        .collection('comments')
        .doc()
        .id;

    await FirebaseFirestore.instance
        .collection('communities')
        .doc(selectedPost.communityId)
        .collection('activities')
        .doc(selectedPost.postID)
        .collection('comments')
        .doc(commentId)
        .set({
      'content': content,
      'userId': currentUserId,
      'userName': 'User Name', // Replace with the user's name
      'createdAt': Timestamp.now(),
      'likes': 0,
    });

    _commentController.clear();
    _loadComments();
  }

  Future<void> _toggleCommentLike(String commentId) async {
    final likedDoc = await FirebaseFirestore.instance
        .collection('communities')
        .doc(selectedPost.communityId)
        .collection('activities')
        .doc(selectedPost.postID)
        .collection('comments')
        .doc(commentId)
        .collection('likes')
        .doc(currentUserId)
        .get();

    if (likedDoc.exists) {
      await likedDoc.reference.delete();
    } else {
      await likedDoc.reference.set({'likedAt': Timestamp.now()});
    }

    _loadComments();
  }

  Future<void> _fetchMentionSuggestions() async {
    final parksSnapshot =
        await FirebaseFirestore.instance.collection('parks').get();
    final businessesSnapshot =
        await FirebaseFirestore.instance.collection('businesses').get();

    final parks =
        parksSnapshot.docs.map((doc) => doc['name'] as String).toList();
    final businesses =
        businessesSnapshot.docs.map((doc) => doc['name'] as String).toList();

    setState(() {
      mentionSuggestions = [...parks, ...businesses];
    });
  }

  void _onCommentChanged(String value) {
    if (value.endsWith('@')) {
      _fetchMentionSuggestions();
    } else {
      setState(() {
        mentionSuggestions.clear();
      });
    }
  }

  void _addMention(String mention) {
    final currentText = _commentController.text;
    final updatedText = '$currentText$mention ';
    _commentController.text = updatedText;
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: updatedText.length),
    );

    mentionSuggestions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post by ${selectedPost.userName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  selectedPost.imageUrl ?? 'https://via.placeholder.com/400',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: GlobalPadding.all,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      selectedPost.activityType ?? 'No title',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedPost.content ?? 'No content',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border),
                          color: isLiked ? Colors.red : Colors.grey,
                          onPressed: _toggleLike,
                        ),
                        const SizedBox(width: 10),
                        Text(isLiked ? 'Liked' : 'Like'),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        contentPadding: GlobalPadding.all,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: primaryColor),
                          onPressed: () => _addComment(_commentController.text),
                        ),
                      ),
                      onChanged: _onCommentChanged,
                    ),
                    if (mentionSuggestions.isNotEmpty)
                      Wrap(
                        children: mentionSuggestions.map((suggestion) {
                          return GestureDetector(
                            onTap: () => _addMention(suggestion),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentId = comment['commentId'];
                        final isLiked = comment['liked'] ?? false;
                        return ListTile(
                          title: Text(
                            comment['content'] ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Posted by ${comment['userName']} on ${comment['createdAt'] != null ? DateFormat.yMMMd().format(comment['createdAt'].toDate()) : 'Unknown date'}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleCommentLike(commentId),
                          ),
                        );
                      },
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
}
