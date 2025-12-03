class Notification {
  final String notificationID;
  final String recipientID;
  final String message;
  final DateTime date;
  final String status;

  Notification({
    required this.notificationID,
    required this.recipientID,
    required this.message,
    required this.date,
    required this.status,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationID: json['notificationID'],
      recipientID: json['recipientID'],
      message: json['message'],
      date: json['date'].toDate(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationID': notificationID,
        'recipientID': recipientID,
        'message': message,
        'date': date,
        'status': status,
      };
}
