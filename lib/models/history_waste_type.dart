class HistoryWasteType {
  final String historyID;
  final String wasteRequestID;
  final DateTime date;
  final String activityType;
  final String activityDetails;

  HistoryWasteType({
    required this.historyID,
    required this.wasteRequestID,
    required this.date,
    required this.activityType,
    required this.activityDetails,
  });

  factory HistoryWasteType.fromJson(Map<String, dynamic> json) {
    return HistoryWasteType(
      historyID: json['historyID'],
      wasteRequestID: json['wasteRequestID'],
      date: json['date'].toDate(),
      activityType: json['activityType'],
      activityDetails: json['activityDetails'],
    );
  }

  Map<String, dynamic> toJson() => {
        'historyID': historyID,
        'wasteRequestID': wasteRequestID,
        'date': date,
        'activityType': activityType,
        'activityDetails': activityDetails,
      };
}
