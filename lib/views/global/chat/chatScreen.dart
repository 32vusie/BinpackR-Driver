import 'package:binpack_residents/models/chatModel.dart';
import 'package:binpack_residents/models/users/driver.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/models/waste_request.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/global/chat/functions/chat_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatefulWidget {
  final WasteCollectionRequest wasteRequest;

  const ChatWidget({super.key, required this.wasteRequest});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with WidgetsBindingObserver {
  final ChatFunctions _chatFunctions = ChatFunctions();
  final TextEditingController _messageController = TextEditingController();

  String? currentUserName;
  String? otherUserName;
  String? otherUserRole;
  String? driverAvatarUrl;
  String? residentAvatarUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchUserDetails();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _chatFunctions.markMessagesAsRead(widget.wasteRequest.wasteRequestID);
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      if (currentUserId == widget.wasteRequest.userID) {
        // Current user is the resident
        Residents user =
            await _chatFunctions.fetchUserData(widget.wasteRequest.userID);
        Driver driver =
            await _chatFunctions.fetchDriverData(widget.wasteRequest.driverID);
        setState(() {
          currentUserName = user.name;
          otherUserName = driver.name;
          otherUserRole = 'Driver';
          driverAvatarUrl = driver.profilePictureUrl;
          residentAvatarUrl = user.profilePictureUrl;
        });
      } else {
        // Current user is the driver
        Driver driver =
            await _chatFunctions.fetchDriverData(widget.wasteRequest.driverID);
        Residents user =
            await _chatFunctions.fetchUserData(widget.wasteRequest.userID);
        setState(() {
          currentUserName = driver.name;
          otherUserName = user.name;
          otherUserRole = 'Resident';
          driverAvatarUrl = driver.profilePictureUrl;
          residentAvatarUrl = user.profilePictureUrl;
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  void _sendMessage(String wasteRequestId) async {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(wasteRequestId)
          .collection('messages')
          .add({
        'text': messageText,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      setState(() {
        _messageController.clear();
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Widget _buildChatMessage(ChatMessage chatMessage) {
    String formattedTime = DateFormat('HH:mm').format(chatMessage.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: chatMessage.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!chatMessage.isSentByMe)
            CircleAvatar(
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.uid ==
                        widget.wasteRequest.userID
                    ? driverAvatarUrl ?? 'https://via.placeholder.com/150'
                    : residentAvatarUrl ?? 'https://via.placeholder.com/150',
              ),
              radius: 16,
            ),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  chatMessage.isSentByMe ? Colors.green[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chatMessage.text != null)
                  Text(chatMessage.text!,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14)),
                if (chatMessage.mediaUrl != null)
                  _buildMediaPreview(chatMessage.mediaUrl!),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(formattedTime,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(String mediaUrl) {
    List<String> urls = mediaUrl.split(',');
    return Wrap(
      spacing: 8,
      children: urls
          .map((url) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMessageInput(String wasteRequestId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(wasteRequestId),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.uid ==
                        widget.wasteRequest.userID
                    ? driverAvatarUrl ?? 'https://via.placeholder.com/150'
                    : residentAvatarUrl ?? 'https://via.placeholder.com/150',
              ),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherUserName ?? 'Chat',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Last seen 5m ago',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.wasteRequest.wasteRequestID)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Widget> messageWidgets = snapshot.data!.docs.map((doc) {
                  return _buildChatMessage(ChatMessage(
                    text: doc['text'],
                    isSentByMe:
                        doc['sender'] == FirebaseAuth.instance.currentUser!.uid,
                    time: doc['timestamp']?.toDate() ?? DateTime.now(),
                    sender: doc['sender'],
                  ));
                }).toList();

                return ListView(reverse: true, children: messageWidgets);
              },
            ),
          ),
          _buildMessageInput(widget.wasteRequest.wasteRequestID),
        ],
      ),
    );
  }
}
