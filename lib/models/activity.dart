class Activity {
  final String activityID;
  final String type; // login, logout, or request pickup
  final DateTime date;

  Activity({
    required this.activityID,
    required this.type,
    required this.date,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityID: json['activityID'],
      type: json['type'],
      date: json['date'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'activityID': activityID,
        'type': type,
        'date': date,
      };
}
