class ChatMessage {
  final String? text;
  final bool isSentByMe;
  final DateTime time;
  final String sender;
  final bool? isRead;
  final String? mediaUrl;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.time,
    required this.sender,
    this.isRead, 
    this.mediaUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSentByMe': isSentByMe,
      'time': time,
      'sender': sender,
      'isRead': isRead,
      'mediaUrl': mediaUrl,
    };
  }
}

