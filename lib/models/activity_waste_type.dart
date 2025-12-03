class ActivityWasteType {
  final String activityID;
  final String userID;
  final DateTime date;
  final String activityType;
  final String activityDetails;

  ActivityWasteType({
    required this.activityID,
    required this.userID,
    required this.date,
    required this.activityType,
    required this.activityDetails,
  });

  factory ActivityWasteType.fromJson(Map<String, dynamic> json) {
    return ActivityWasteType(
      activityID: json['activityID'],
      userID: json['userID'],
      date: json['date'].toDate(),
      activityType: json['activityType'],
      activityDetails: json['activityDetails'],
    );
  }

  Map<String, dynamic> toJson() => {
        'activityID': activityID,
        'userID': userID,
        'date': date,
        'activityType': activityType,
        'activityDetails': activityDetails,
      };
}
